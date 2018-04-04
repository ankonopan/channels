defmodule Channels.Model.Repos.PageTest do
  use ChannelsWeb.ConnCase

  setup do
    Mongo.delete_many(:mongo, "pages", %{})
    :ok
  end

  doctest Channels.Model.Repos.Page
end
