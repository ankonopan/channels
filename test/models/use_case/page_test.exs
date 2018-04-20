defmodule Channels.Model.UseCase.PageTest do
  use ChannelsWeb.ConnCase
  use Channels.Model

  setup do
    site = %Type.Site{id: "43lkj34", name: "Some Site", host: "www.someplace.com"}

    Mongo.delete_many(Repo.User.connection, Repo.User.collection, %{})
    Mongo.delete_many(Repo.Site.connection, Repo.Site.collection, %{})
    Mongo.delete_many(:mongo, Repo.Page.collection(site), %{})

    %{fields: %{title: "Muu", meta_title: "Muu", content: "Muu"}, site: site }
  end

  test "Creates a valid page on DB", %{fields: fields} do
    element = %{name: "issue", content: %{id: 34}, type: "issue"}
    cell = %{name: "default", elements: [element]}
    page  = %{title: "Some Title", content: "Some Description", cells: [cell]}

    {:ok, user} = UseCase.User.create(%{name: "Samuel", email: "sam@sam.com"})
    {:ok, site} = UseCase.Site.create(%{name: "SomeSite", host: "sam.com"})
    {status, page} = UseCase.Page.create({site, page, user})

    assert status === :ok
  end
end
