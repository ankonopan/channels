defmodule Channels.Model.Repos.Page do
  @moduledoc """
  Provides Mongo Repository CRUD methods for Pages

  """
  use Channels.Model.Utils.Repo, %{connection: :mongo, collection: "pages"}
end
