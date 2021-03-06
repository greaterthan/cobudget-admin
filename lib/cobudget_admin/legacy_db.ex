defmodule CobudgetAdmin.LegacyDb do
  import Ecto.Query

  alias CobudgetAdmin.Repo
  alias CobudgetAdmin.LegacyDb.Group
  alias CobudgetAdmin.LegacyDb.Bucket
  alias CobudgetAdmin.LegacyDb.Allocation
  alias CobudgetAdmin.LegacyDb.User
  alias CobudgetAdmin.LegacyDb.Membership
  alias CobudgetAdmin.LegacyDb.Contribution
  alias CobudgetAdmin.LegacyDb.Comment

  def group_analytics() do
    bucket_q = from b in Bucket, 
      where: b.status == "funded",
      group_by: b.group_id, 
      select: %{id: b.group_id, cnt: count(b.group_id), total: sum(b.target)}

    update_q = from b in Bucket,
      join: cm in Comment, on: b.id == cm.bucket_id,
      join: co in Contribution, on: b.id == co.bucket_id,
      group_by: b.group_id,
      select: %{id: b.group_id, bucket_update: max(b.updated_at),
                comment_update: max(cm.updated_at),
                contribution_update: max(co.updated_at)}

    allocation_q = from a in Allocation,
      group_by: a.group_id,
      select: %{id: a.group_id, total: sum(a.amount), update: max(a.updated_at)}

    members_q = from m in Membership,
      join: u in User, on: m.member_id == u.id,
      group_by: m.group_id,
      select: %{id: m.group_id, update: max(m.updated_at),
                confirmed: fragment("(SUM(CASE WHEN confirmed_at IS NULL THEN 0 ELSE 1 END))"),
                unconfirmed: fragment("(SUM(CASE WHEN confirmed_at IS NULL THEN 1 ELSE 0 END))")}

    q = from g in Group,
      left_join: b in subquery(bucket_q), on: b.id == g.id,
      left_join: a in subquery(allocation_q), on: a.id == g.id,
      left_join: m in subquery(members_q), on: m.id == g.id,
      left_join: u in subquery(update_q), on: u.id == g.id,
      order_by: [desc: g.created_at],
      select: %{id: g.id, name: g.name, currency_code: g.currency_code,
                created_at: g.created_at, cnt: b.cnt, funded_total: b.total,
                allocated: a.total, confirmed_users: m.confirmed,
                unconfirmed_users: m.unconfirmed, 
                bucket_update: u.bucket_update,
                comment_update: u.comment_update,
                contribution_update: u.contribution_update,
                member_update: m.update, allocation_update: a.update}

    Repo.all(q)
  end

  def buckets() do

    contrib_q = from c in Contribution,
    group_by: c.bucket_id,
    select: %{bucket_id: c.bucket_id, amount: sum(c.amount)}

    q = from b in Bucket,
    join: g in Group, on: b.group_id == g.id,
    left_join: c in subquery(contrib_q), on: b.id == c.bucket_id,
    order_by: [g.name, b.name],
    select: %{id: b.id, name: b.name, group: g.name, created_at: b.created_at, status: b.status,
              live_at: b.live_at, funded_at: b.funded_at, archived_at: b.archived_at,
              paid_at: b.paid_at, contributed: c.amount, currency_symbol: g.currency_symbol}

    Repo.all(q)
  end

  def bucket_contributions(bucket) do
    q = from c in Contribution,
        join: u in User, on: c.user_id == u.id,
        where: c.bucket_id == ^bucket,
        order_by: c.created_at,
        select: %{id: c.id, user: u.name, created_at: c.created_at, amount: c.amount}

    Repo.all(q)
  end
end
