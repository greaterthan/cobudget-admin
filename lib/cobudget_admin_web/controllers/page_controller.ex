defmodule CobudgetAdminWeb.PageController do
  use CobudgetAdminWeb, :controller

  alias CobudgetAdmin.LegacyDb

  def index(conn, _params) do
    render(conn, "index.html", groups: LegacyDb.group_analytics())
  end

  def buckets(conn, _params) do
    render(conn, "buckets.html", buckets: LegacyDb.buckets())
  end

  def contributions(conn, %{"bucket_id" => bucket_id}) do
    render(conn, "contributions.html", contributions: LegacyDb.bucket_contributions(bucket_id),
           bucket_id: bucket_id)
  end
end
