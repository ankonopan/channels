defmodule Channels.Model.Repos.SiteTest do
  use ChannelsWeb.ConnCase
  alias Channels.Model.Repos
  alias Channels.Model.DataType, as: Type

  @fields  %{name: "My Site", host: "www.somehost.com", id: "3sf393fa3f"}
  @empty_site %Type.Site{}

  setup do
    Mongo.delete_many(Repos.Site.connection, Repos.Site.collection, %{})
    :ok
  end

  test "Create a record on given db" do
    %{changes: changes} = @empty_site |> Type.Site.changeset(@fields)
    {status, _} = Repos.Site.create(changes)
    assert status === :ok
  end

  test "Update mongo db with given changeset" do
    %{changes: changes} = @empty_site |> Type.Site.changeset(@fields)
    {:ok, %{id: id}} = Repos.Site.create(changes)

    {:ok, record} = Repos.Site.find(id)

    %{changes: changes} = record |> Type.Site.changeset(%{name: "Sa"})

    {status, %{name: name}} = Repos.Site.update(id, changes)

    assert status === :ok
    assert name === "Sa"
  end

  test "Find a document on the collection" do
    %{changes: changes} = @empty_site |> Type.Site.changeset(@fields)
    {_, %{id: id}} = Repos.Site.create(changes)

    {status, _} = Repos.Site.find(id)
    assert status === :ok
  end

  test "Find all documents in given collection" do
    %{changes: changes} = @empty_site |> Type.Site.changeset(@fields)
    Repos.Site.create(changes)

    {status, list} = Repos.Site.all()
    assert status === :ok
    assert length(list) === 1
  end

  test "Find all documents in given collection with given filters" do
    %{changes: changes} = @empty_site |> Type.Site.changeset(@fields)
    {status, _} = Repos.Site.create(changes)
    assert status === :ok
    {status, results} = Channels.Model.Repos.Site.all(%{name: "My Site"})
    assert status === :ok
    assert length(results) === 1
    {status, []} = Channels.Model.Repos.Site.all(%{"name" => "Saaa"})
    assert status === :ok
  end
end
