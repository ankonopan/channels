defmodule Channels.Model.DataType.Cell do
  alias __MODULE__
  use ChannelsWeb, :document
  require Logger

  use Channels.Model
  import Type.Utils.Record

  embedded_schema do
    field :name,      :string
    embeds_many :elements, Type.Element

    # Page 1 -> * Cells 1 -> * Elements
    # %Cell{
    #   name: "Shuu",
    #   elements: [
    #     %Element{type: "Issue", value: ""}
    #     ]}
    timestamps()
  end

  @doc """
  Convert a Map into a changeset for MongoDB manipulation


  """
  @allowed_params [:name]
  @optional_params []
  @required_params [:name]

  @spec changeset(cell, map) :: cell
  def changeset(cell \\ %Cell{}, params) do
    cell
      |> cast(params, @allowed_params, @optional_params)
      |> cast_embed(:elements, required: false)
      |> validate_required(@required_params)
  end

  def decast(cell) do
    cell
      |> update_timestamps
      |> Map.replace!(:elements, Enum.map(cell.elements, &Type.Element.decast/1))
      |> Map.from_struct
  end
end
