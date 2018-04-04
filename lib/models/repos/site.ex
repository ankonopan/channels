defmodule Channels.Model.Repos.Site do
  @moduledoc """
  Provides Mongo Repository CRUD methods for Sites

  """
  use Channels.Model.Utils.Repo, %{connection: :mongo, collection: "sites"}
end
