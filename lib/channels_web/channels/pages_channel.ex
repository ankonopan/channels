defmodule Channels.PagesChannel do
  use ChannelsWeb, :channel

  def join("pages", _params, socket) do
    {:ok, pages} = Channels.Model.Page.all()
    response = %{
      pages: pages
    }

    {:ok, response, socket}
  end

  def handle_in("new", params, socket) do
    %{changes: changes} = Channels.Model.Page.changeset(%Channels.Model.Page{}, params)
    {:ok, page} = Channels.Model.Page.create(changes)

    broadcast!(socket, "page_new", %{page: page})
    {:reply, :ok, socket}
  end
end
