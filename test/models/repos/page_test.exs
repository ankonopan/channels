defmodule Channels.Model.Repos.PageTest do
  use ChannelsWeb.ConnCase
  @fields   %{title: "Muu", meta_title: "Muu", content: "Muu"}
  @site     %Channels.Model.Site{id: "43lkj34", name: "Some Site", host: "www.someplace.com"}

  def create_page(site, fields) do
    %{changes: changes} = Channels.Model.Page.changeset(fields)
    site |> Channels.Model.Repos.Page.create(changes)
  end

  setup do
    Mongo.delete_many(:mongo, Channels.Model.Repos.Page.collection(@site), %{})
    :ok
  end

  test "Create a record on given db" do
    {status, _} = create_page(@site, @fields)
    assert status === :ok
  end

  test "Update mongo db with given changeset" do
    {:ok, %{"id" => id}} =  create_page(@site, @fields)
    {status, record} = @site |> Channels.Model.Repos.Page.find(id)

    new_field = %{"title" => "Sa"}
    %{changes: changes} = Channels.Model.Page.changeset(Map.merge(record, new_field))

    {status, %{"title" => title}} = @site |> Channels.Model.Repos.Page.update(id, changes)

    assert status === :ok
    assert title === "Sa"
  end

  test "Find a document on the collection" do
    {_, %{"id" => id}} = create_page(@site, @fields)

    {status, _} = @site |> Channels.Model.Repos.Page.find(id)
    assert status === :ok
  end

  test "Find all documents in given collection" do
    create_page(@site, @fields)

    {status, list} = @site |> Channels.Model.Repos.Page.all()
    assert status === :ok
    assert length(list) === 1
  end

  test "Find all documents in given collection with given filters" do
    {status, _} =  create_page(@site, @fields)
    assert status === :ok
    {status, results} = @site |> Channels.Model.Repos.Page.all(%{title: "Muu"})
    assert status === :ok
    assert length(results) === 1
    {status, []} = @site |> Channels.Model.Repos.Page.all(%{"title" => "Saaa"})
    assert status === :ok
  end
end
