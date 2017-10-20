defmodule CobudgetAdmin.LegacyDb.Allocation do
  use Ecto.Schema

  schema "allocations" do
    field :user_id, :integer
    field :group_id, :integer
    field :amount, :decimal

    timestamps(inserted_at: :created_at)
  end
end
