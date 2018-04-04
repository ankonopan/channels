defmodule Channels.Model.Page do
  use ChannelsWeb, :document
  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}  # the id maps to uuid
  schema "pages" do
    field :title, :string
    field :meta_title, :string
    field :content, :string
  end

  @doc """
  Convert a Map into a changeset for MongoDB manipulation


  """
  def changeset(params \\ %{}) do
    %Channels.Model.Page{}
      |> cast(params, [:title, :meta_title, :content])
      |> validate_required([:title, :content])
  end
end
