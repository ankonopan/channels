defmodule Channels.PagesChannel do
  use ChannelsWeb, :channel

  def join("pages", _params, socket) do
    {:ok, pages} = Channels.Model.Repos.Page.all()
    response = %{
      pages: pages
    }

    {:ok, response, socket}
  end

  def handle_in("new", params, socket) do
    %{changes: changes} = Channels.Model.Page.changeset(params)
    {:ok, page} = Channels.Model.Repos.Page.create(changes)

    broadcast!(socket, "page_new", %{page: page})
    {:reply, :ok, socket}
  end
end
