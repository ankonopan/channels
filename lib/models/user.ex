defmodule Channels.Model.User do
  alias __MODULE__
  use ChannelsWeb, :document
  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}  # the id maps to uuid
  schema "users" do
    field :name,  :string
    field :email, :string
  end

  @doc """
  Convert a Map into a changeset for MongoDB manipulation


  """
  @allowed_params [:name, :email]
  @required_params [:name, :email]

  def changeset(user \\ %User{}, params) do
    user
      |> cast(params, @allowed_params)
      |> validate_required(@required_params)
  end
end
