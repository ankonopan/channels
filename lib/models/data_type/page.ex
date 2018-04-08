defmodule Channels.Model.DataType.Page do
  alias __MODULE__
  use ChannelsWeb, :document
  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}  # the id maps to uuid
  schema "pages" do
    field :title, :string
    field :meta_title, :string
    field :content, :string
    field :site_id, :string
  end

  @doc """
  Convert a Map into a changeset for MongoDB manipulation


  """
  @allowed_params [:title, :meta_title, :content, :site_id]
  @required_params [:title, :content, :site_id]

  def changeset(params) do
    %Page{}
      |> cast(params, @allowed_params)
      |> validate_required(@required_params)
  end
end
