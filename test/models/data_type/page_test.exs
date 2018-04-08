defmodule Channels.Model.DataType.PageTest do
  use ChannelsWeb.ConnCase

  setup do
    Mongo.delete_many(:mongo, "pages", %{})
    :ok
  end

  doctest Channels.Model.DataType.Page
end
