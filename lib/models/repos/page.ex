defmodule Channels.Model.Repos.Page do
  @moduledoc """
  Provides Mongo Repository CRUD methods for Pages

  """
  use Channels.Model.Utils.Repo

  def connection(site) do
    :mongo
  end

  def collection(site) do
    "#{Channels.Model.DataType.Site.collection_id(site)}_pages"
  end
end
