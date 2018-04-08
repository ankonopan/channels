defmodule Channels.Model.Repo.User do
  @moduledoc """
  Provides Mongo Repository CRUD methods for Pages

  """
  alias __MODULE__
  use Channels.Model
  use Protocol.Repository

  @connection :mongo
  @collection "users"

  def connection, do: @connection
  def collection, do: @collection

  @doc nil
  @spec record_to_map(map) :: user
  defp record_to_map(record) do
    record
      |> Map.put("id", BSON.ObjectId.encode!(record["_id"]))
      |> Channels.Utils.Map.Transformations.atomize_keys
      # This revert the order of the arguments: look at http://shulhi.com/piping-to-second-argument-in-elixir/
      |> (&Map.merge(%Type.User{}, &1)).()
  end
end
