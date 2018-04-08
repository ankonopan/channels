defmodule Channels.Model.Repo.Page do
  @moduledoc """
  Provides Mongo Repository CRUD methods for Pages

  """
  alias __MODULE__
  use Channels.Model
  use Protocol.SiteRepository

  def connection(_) do
    :mongo
  end

  def collection(site) do
    "#{Type.Site.collection_id(site)}_pages"
  end

  defp record_to_map(record) do
    record
    |> Map.put("id", BSON.ObjectId.encode!(record["_id"]))
    |> Channels.Utils.Map.Transformations.atomize_keys()
    # This revert the order of the arguments: look at http://shulhi.com/piping-to-second-argument-in-elixir/
    |> (&Map.merge(%Type.Page{}, &1)).()
  end
end
