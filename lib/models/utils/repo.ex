defmodule Channels.Model.Utils.Repo do
  @moduledoc """
  Provides a standard Protocol for Mongo Repositories

  """
  defmacro __using__(params) do
    quote do
      params = unquote(params)

      @connection params.connection
      @collection params.collection

      def connection do @connection end
      def collection do @collection end


      @doc nil
      def create(changes) do
        response = Mongo.insert_one(@connection, @collection, changes)
        case response do
          {:ok, %Mongo.InsertOneResult{inserted_id: bson_id}} ->
            find(bson_id)
          True ->
            response
        end
      end

      @doc nil
      def update(id, replacement) do
        # This may not need to be done but it is done to run validations over the new data
        {:ok, record} = find(id)
        query = %{_id: objectId(id)}
        response = Mongo.update_one(@connection, @collection, query, %{"$set": replacement}, return_document: :after)
        case response do
          {:ok, _} ->
            find(id)
          _ ->
            response
        end
      end

      @doc nil
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

      @doc nil
      def all() do
        list = Mongo.find(@connection, @collection, %{}) |> Enum.to_list
        {:ok, list |> Enum.map(&record_to_map/1)}
      end

      @doc nil
      def all(filters) do
        list = Mongo.find(@connection, @collection, filters) |> Enum.to_list
        {:ok, list |> Enum.map(&record_to_map/1)}
      end

      # def log(response, message) do
      #   Logger.info("#{message} #{inspect(response)}")
      #   response
      # end

      @doc nil
      def record_to_map(record) do
        %{"_id" => id} = record
        record
          |> Map.drop(["_id"])
          |> Map.put("id", BSON.ObjectId.encode!(id))
      end
    end
  end
end
