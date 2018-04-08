defmodule Channels.Model.Protocol.Repository do
  @moduledoc """
  Provides a standard library for Mongo Repositories

  """
  use Channels.Model

  @callback connection() :: atom
  @callback collection() :: String.t
  @callback record_to_map(map) :: map

  defmodule NonImplementedError do
    defexception message: "This function needs to be implemented on the including module"
  end

  defmacro __using__(_params) do
    quote do
      @behaviour __MODULE__
      alias __MODULE__

      @doc nil
      @spec find(String.t) :: boolean
      def exists?(id) do
        {:ok, 1} === Mongo.count(connection(), collection(), %{_id: objectId(id)})
      end

      @doc nil
      @spec find(String.t) :: result
      def find(id) do
        cursor = Mongo.find(connection(), collection(), %{_id: objectId(id)}, limit: 1)
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
      @spec all() :: results
      def all() do
        list = Mongo.find(connection(), collection(), %{})
                |> Enum.to_list
        {:ok, list |> Enum.map(&record_to_map/1)}
      end

      @doc nil
      @spec all(map) :: result
      def all(filters) do
        list = Mongo.find(connection(), collection(), filters)
                |> Enum.to_list
        {:ok, list |> Enum.map(&record_to_map/1)}
      end

      @doc nil
      @spec create(map) :: result
      def create(changes) do
        response = Mongo.insert_one(connection(), collection(), changes)
        case response do
          {:ok, %Mongo.InsertOneResult{inserted_id: bson_id}} ->
            find(bson_id)
          True ->
            response
        end
      end

      @doc nil
      @spec update(String.t, map) :: result
      def update(id, replacement) do
        # This may not need to be done but it is done to run validations over the new data
        {:ok, record} = find(id)
        query = %{_id: objectId(id)}
        response = Mongo.update_one(connection(), collection(), query, %{"$set": replacement}, return_document: :after)
        case response do
          {:ok, _} ->
            find(id)
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
