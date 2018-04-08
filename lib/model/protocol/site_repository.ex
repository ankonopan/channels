defmodule Channels.Model.Protocol.SiteRepository do
  @moduledoc """
  Provides a standard library for Mongo Repositories

  """
  use Channels.Model

  @callback connection(site) :: atom
  @callback collection(site) :: String.t
  @callback record_to_map(map) :: map

  defmodule NonImplementedError do
    defexception message: "This function needs to be implemented on the including module"
  end

  defmacro __using__(_params) do
    quote do
      @behaviour __MODULE__
      alias __MODULE__


      @doc nil
      @spec find(Repo.site, String.t) :: boolean
      def exists?(site, id) do
        {:ok, 1} === Mongo.count(connection(site), collection(site), %{_id: objectId(id)})
      end

      @doc nil
      @spec find(Repo.site, String.t) :: Repo.result
      def find(site, id) do
        cursor = Mongo.find(connection(site), collection(site), %{_id: objectId(id)}, limit: 1)
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

      @doc nil
      @spec all(Repo.site) :: Repo.results
      def all(site) do
        list = Mongo.find(connection(site), collection(site), %{})
                |> Enum.to_list
        {:ok, list |> Enum.map(&record_to_map/1)}
      end

      @doc nil
      @spec all(Repo.site, map) :: Repo.result
      def all(site, filters) do
        list = Mongo.find(connection(site), collection(site), filters)
                |> Enum.to_list
        {:ok, list |> Enum.map(&record_to_map/1)}
      end

      @doc nil
      @spec create(Repo.site, map) :: Repo.result
      def create(site, changes) do
        response = Mongo.insert_one(connection(site), collection(site), changes)
        case response do
          {:ok, %Mongo.InsertOneResult{inserted_id: bson_id}} ->
            find(site, bson_id)
          True ->
            response
        end
      end

      @doc nil
      @spec update(Repo.site, String.t, map) :: Repo.result
      def update(site, id, replacement) do
        # This may not need to be done but it is done to run validations over the new data
        {:ok, record} = find(site, id)
        query = %{_id: objectId(id)}
        response = Mongo.update_one(connection(site), collection(site), query, %{"$set": replacement}, return_document: :after)
        case response do
          {:ok, _} ->
            find(site, id)
          _ ->
            response
        end
      end

      @doc nil
      @spec objectId(String.t) :: map
      defp objectId(id) when Kernel.is_bitstring(id) do
        {_, idbin} = Base.decode16(id, case: :mixed)
        %BSON.ObjectId{value: idbin}
      end

      @doc nil
      @spec objectId(map) :: map
      defp objectId(id) do id end
    end
  end
end
