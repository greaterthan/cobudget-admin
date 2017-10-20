defmodule CobudgetAdmin.LegacyDb.Group do
  use Ecto.Schema
  use Timex.Ecto.Timestamps

  schema "groups" do
    field :name, :string
    field :currency_symbol, :string
    field :currency_code, :string
    field :customer_id, :string
    field :trial_end, :naive_datetime
    field :plan, :string

    timestamps(inserted_at: :created_at)
  end
end
