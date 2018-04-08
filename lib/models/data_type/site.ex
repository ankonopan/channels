defmodule Channels.Model.DataType.Site do
  alias __MODULE__
  use ChannelsWeb, :document
  require Logger

  @type site :: __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}  # the id maps to uuid
  schema "sites" do
    field :name, :string
    field :host, :string, unique: true
    field :aliases, {:array, :string}
    field :default_site, :boolean, default: false
  end

  @doc """
  Convert a Map into a changeset for MongoDB manipulation


  """
  @allowed_params [:name, :host, :aliases]
  @required_params [:name, :host]

  @spec changeset(site, map) :: site
  def changeset(site\\ %Site{}, params) do
    site
      |> cast(params, @allowed_params)
      |> validate_required(@required_params)
  end

  def collection_id(%Site{id: id}) do
    :crypto.hash(:md5, id)
      |> Base.encode16
      |> String.downcase
  end
end
