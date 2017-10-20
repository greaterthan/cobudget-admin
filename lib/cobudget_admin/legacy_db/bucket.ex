defmodule CobudgetAdmin.LegacyDb.Bucket do
  use Ecto.Schema

  schema "buckets" do
    field :name, :string
    field :description, :string
    field :user_id, :integer
    field :target, :integer
    field :group_id, :integer
    field :status, :string
    field :funding_closes_at, :naive_datetime
    field :funded_at, :naive_datetime
    field :live_at, :naive_datetime
    field :archived_at, :naive_datetime
    field :paid_at, :naive_datetime

    timestamps(inserted_at: :created_at)
  end
end
