defmodule CobudgetAdmin.LegacyDb.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :encryped_password, :string
    field :reset_password_token, :string
    field :reset_password_sent_at, Timex.Ecto.DateTime
    field :remember_created_at, Timex.Ecto.DateTime
    field :sign_in_count, :integer
    field :current_sign_in_at, Timex.Ecto.DateTime
    field :last_sign_in_at, Timex.Ecto.DateTime
    field :current_sign_in_ip, :string
    field :last_sign_in_ip, :string
    field :name, :string
    field :tokens, :string
    field :provider, :string
    field :uid, :string
    field :confirmation_token, :string
    field :utc_offset, :integer
    field :confirmed_at, Timex.Ecto.DateTime
    field :joined_first_group_at, Timex.Ecto.DateTime
    field :is_super_admin, :boolean

    timestamps(inserted_at: :created_at)
  end
end
