defmodule Channels.Model.Repos.Page do
  @moduledoc """
  Provides Mongo Repository CRUD methods for Pages

  """
  @connection :mongo
  @collection "pages"
  alias Channels.Model.Page, as: Page

  @doc """
  Create a record on given db

  ## Examples
      iex> fields = %{title: "Muu", meta_title: "Muu", content: "Muu"}
      iex> %{changes: changes} = Channels.Model.Page.changeset(fields)
      iex> {status, _} = Channels.Model.Repos.Page.create(changes)
      iex> status
      :ok
  """
  def create(changes) do
    response = Mongo.insert_one(@connection, @collection, changes)
    case response do
      {:ok, %Mongo.InsertOneResult{inserted_id: bson_id}} ->
        find(bson_id)
      True ->
        response
    end
  end

  @doc """
  Update mongo db with given changeset

  ## Examples
      iex> fields = %{title: "Muu", meta_title: "Muu", content: "Muu"}
      iex> %{changes: changes} = Channels.Model.Page.changeset(fields)
      iex> {:ok, %{"id" => id}} = Channels.Model.Repos.Page.create(changes)
      iex> {status, _} = Channels.Model.Repos.Page.update(id, %{"title" => "Sa"})
      iex> status
      :ok
  """
  def update(id, replacement) do
    # This may not need to be done but it is done to run validations over the new data
    {:ok, record} = find(id)
    %{changes: changes} = Page.changeset(Map.merge(record, replacement))
    query = %{_id: objectId(id)}
    response = Mongo.update_one(@connection, @collection, query, %{"$set": changes}, return_document: :after)
    case response do
      {:ok, _} ->
        find(id)
      _ ->
        response
    end
  end

  @doc """
  Find a document on the DB

  ## Examples
      iex> fields = %{title: "Muu", meta_title: "Muu", content: "Muu"}
      iex> %{changes: changes} = Channels.Model.Page.changeset(fields)
      iex> {_, %{"id" => id}} = Channels.Model.Repos.Page.create(changes)
      iex>
      iex> {status, _} = Channels.Model.Repos.Page.find(id)
      iex> status
      :ok
  """
  def find(id) do
    cursor = Mongo.find(@connection, @collection, %{_id: objectId(id)}, limit: 1)
    list = Enum.to_list(cursor)
    case length(list) do
      1 ->
        {:ok, list
                |> hd
                |> record_to_map}
      any ->
        {:error, "There are #{any} amount of pages"}
    end
  end

  def objectId(id) when Kernel.is_bitstring(id) do
    {_, idbin} = Base.decode16(id, case: :mixed)
    %BSON.ObjectId{value: idbin}
  end

  def objectId(id) do id end

  @doc """
  Find all documents in given collection

  ## Examples
      iex> fields = %{title: "Muu", meta_title: "Muu", content: "Muu"}
      iex> %{changes: changes} = Channels.Model.Page.changeset(fields)
      iex> Channels.Model.Repos.Page.create(changes)
      iex>
      iex> {status, _} = Channels.Model.Repos.Page.all()
      iex> status
      :ok
  """
  def all() do
    list = Mongo.find(@connection, @collection, %{}) |> Enum.to_list
    {:ok, list |> Enum.map(&record_to_map/1)}
  end

  @doc """
  Find all documents in given collection with given filters

  ## Examples
      iex> fields = %{title: "Muu", meta_title: "Muu", content: "Muu"}
      iex> %{changes: changes} = Channels.Model.Page.changeset(fields)
      iex> {status, _} = Channels.Model.Repos.Page.create(changes)
      iex> status
      :ok
      iex> {status, results} = Channels.Model.Repos.Page.all(%{title: "Muu"})
      iex> status
      :ok
      iex> length(results)
      1
      iex> {status, []} = Channels.Model.Repos.Page.all(%{"title" => "Saaa"})
      iex> status
      :ok
  """
  def all(filters \\ %{}) do
    list = Mongo.find(@connection, @collection, filters) |> Enum.to_list
    {:ok, list |> Enum.map(&record_to_map/1)}
  end

  # def log(response, message) do
  #   Logger.info("#{message} #{inspect(response)}")
  #   response
  # end


  def record_to_map(record) do
    %{"_id" => id} = record
    record
      |> Map.drop(["_id"])
      |> Map.put("id", BSON.ObjectId.encode!(id))
  end
end
