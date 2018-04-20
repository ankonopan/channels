defmodule Channels.Model.DataType.Element do
  alias __MODULE__
  use ChannelsWeb, :document
  require Logger

  use Channels.Model
  import Type.Utils.Record

  embedded_schema do
    field :name,      :string
    field :content,   :map
    field :type,      :string

    timestamps()
  end

  @doc """
  Convert a Map into a changeset for MongoDB manipulation


  """
  @allowed_params [:name, :content, :type]
  @required_params [:name, :content, :type]

  @spec changeset(element, map) :: element
  def changeset(element \\ %Element{}, params) do
    element
      |> cast(params, @allowed_params)
      |> validate_required(@required_params)
  end

  def decast(element) do
    element
      |> update_timestamps
      |> Map.from_struct
  end
end
