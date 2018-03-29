defmodule Channels.Model.Page do
  use ChannelsWeb, :document
  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}  # the id maps to uuid
  schema "pages" do
    field :title, :string
    field :meta_title, :string
    field :content, :string
  end

  def changeset(page, params \\ %{}) do
    page
      |> cast(params, [:title, :meta_title, :content])
      |> validate_required([:title, :content])
  end

  @doc """
  Update mongo db with given changeset

  ## Examples
      iex> page = Channels.Model.Page.changeset(%Channels.Model.Page{}, %{title: "Muu", meta_title: "Muu", content: "Muu"})
      iex> {status, record} = Channels.Model.Page.update_db(page.changes)
      iex> status
      :ok
  """
  def update_db(changes) do
    Mongo.find_one_and_replace(:mongo, "pages", %{}, changes, [return_document: :after, upsert: :true])
      |> log("created new page")
  end

  @doc """
  Find a document on the DB

  ## Examples
      iex> {status, record} = Channels.Model.Page.find("5abce5baf343fdd1ff599ee0")
      iex> status
      :ok
  """
  def find(id) do
    cursor = Mongo.find(:mongo, "pages", %{_id: objectid(id)}, limit: 1)
    list = Enum.to_list(cursor)
    if length(list) == 1 do
      {:ok, hd(list)}
    else
      {:error, nil}
    end
  end

  def objectid(id) do
    {_, idbin} = Base.decode16(id, case: :mixed)
    %BSON.ObjectId{value: idbin}
  end

  def all() do
    cursor = Mongo.find(:mongo, "pages", %{})
    list = Enum.to_list(cursor)
    {:ok, list}
  end

  def all(params \\ %{}, options \\ %{}) do
    cursor = Mongo.find(:mongo, "pages", params, options)
    list = Enum.to_list(cursor)
    {:ok, list}
  end

  def log(response, message) do
    Logger.info("#{message} #{inspect(response)}")
    response
  end
end
