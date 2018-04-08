defmodule Channels.PagesChannel do
  use ChannelsWeb, :channel

  alias Channels.Model.DataType.Page, as: Page
  alias Channels.Model.Repo.Page, as: PageRepo

  def join("pages", _params, socket) do
    {:ok, pages} = PageRepo.all()
    response = %{
      pages: pages
    }

    {:ok, response, socket}
  end

  def handle_in("new", params, socket) do
    %{changes: changes} = Page.changeset(params)
    {:ok, page} = PageRepo.create(changes)

    broadcast!(socket, "page_new", %{page: page})
    {:reply, :ok, socket}
  end
end
