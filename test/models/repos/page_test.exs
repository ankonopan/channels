defmodule Channels.Model.Repo.PageTest do
  alias Channels.Model.DataType.Page, as: PageType
  alias Channels.Model.DataType.Site, as: SiteType
  alias Channels.Model.Repo.Page, as: PageRepo

  use ChannelsWeb.ConnCase
  @fields   %{title: "Muu", meta_title: "Muu", content: "Muu"}
  @site     %SiteType{id: "43lkj34", name: "Some Site", host: "www.someplace.com"}

  def create_page(site, fields) do
    %{changes: changes} = PageType.changeset(%PageType{}, fields)
    site |> PageRepo.create(changes)
  end

  setup do
    Mongo.delete_many(:mongo, PageRepo.collection(@site), %{})
    :ok
  end

  test "Create a record on given db" do
    {status, _} = create_page(@site, @fields)
    assert status === :ok
  end

  test "Update mongo db with given changeset" do
    {:ok, %{"id" => id}} =  create_page(@site, @fields)
    {:ok, record} = @site |> PageRepo.find(id)

    new_field = %{"title" => "Sa"}
    %{changes: changes} = PageType.changeset(%PageType{}, Map.merge(record, new_field))

    {status, %{"title" => title}} = @site |> PageRepo.update(id, changes)

    assert status === :ok
    assert title === "Sa"
  end

  test "Find a document on the collection" do
    {_, %{"id" => id}} = create_page(@site, @fields)

    {status, _} = @site |> PageRepo.find(id)
    assert status === :ok
  end

  test "Find all documents in given collection" do
    create_page(@site, @fields)

    {status, list} = @site |> PageRepo.all()
    assert status === :ok
    assert length(list) === 1
  end

  test "Find all documents in given collection with given filters" do
    {status, _} =  create_page(@site, @fields)
    assert status === :ok
    {status, results} = @site |> PageRepo.all(%{title: "Muu"})
    assert status === :ok
    assert length(results) === 1
    {status, []} = @site |> PageRepo.all(%{"title" => "Saaa"})
    assert status === :ok
  end
end
