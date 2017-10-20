defmodule Dbtest.Contribution do
  use Ecto.Schema

  schema "contributions" do
    field :user_id, :integer
    field :bucket_id, :integer
    field :amount, :integer

    timestamps(inserted_at: :created_at)
  end
end
