defmodule Dbtest.Membership do
  use Ecto.Schema

  schema "memberships" do
    field :group_id, :integer
    field :member_id, :integer
    field :is_admin, :boolean
    field :archived_at, Timex.Ecto.DateTime
    field :closed_member_help_card_at, Timex.Ecto.DateTime
    field :closed_admin_help_card_at, Timex.Ecto.DateTime

    timestamps(inserted_at: :created_at)
  end
end
