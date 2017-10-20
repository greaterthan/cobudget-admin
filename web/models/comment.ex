defmodule Dbtest.Comment do
  use Ecto.Schema

  schema "comments" do
    field :body, :string
    field :user_id, :integer
    field :bucket_id, :integer

    timestamps(inserted_at: :created_at)
  end
end
