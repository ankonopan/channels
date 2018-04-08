defmodule Channels.Model.Repos.SiteTest do
  use ChannelsWeb.ConnCase
  @fields  %{name: "My Site", host: "www.somehost.com", id: "3sf393fa3f"}

  setup do
    Mongo.delete_many(Channels.Model.Repos.Site.connection, Channels.Model.Repos.Site.collection, %{})
    :ok
  end

  test "Create a record on given db" do
    %{changes: changes} = Channels.Model.DataType.Site.changeset(@fields)
    {status, _} = Channels.Model.Repos.Site.create(changes)
    assert status === :ok
  end

  test "Update mongo db with given changeset" do
    %{changes: changes} = Channels.Model.DataType.Site.changeset(@fields)
    {:ok, %{"id" => id}} = Channels.Model.Repos.Site.create(changes)

    {status, record} = Channels.Model.Repos.Site.find(id)

    new_field = %{"name" => "Sa"}

    %{changes: changes} = Channels.Model.DataType.Site.changeset(Map.merge(record, new_field))

    {status, %{"name" => name}} = Channels.Model.Repos.Site.update(id, changes)

    assert status === :ok
    assert name === "Sa"
  end

  test "Find a document on the collection" do
    %{changes: changes} = Channels.Model.DataType.Site.changeset(@fields)
    {_, %{"id" => id}} = Channels.Model.Repos.Site.create(changes)

    {status, _} = Channels.Model.Repos.Site.find(id)
    assert status === :ok
  end

  test "Find all documents in given collection" do
    %{changes: changes} = Channels.Model.DataType.Site.changeset(@fields)
    Channels.Model.Repos.Site.create(changes)

    {status, list} = Channels.Model.Repos.Site.all()
    assert status === :ok
    assert length(list) === 1
  end

  test "Find all documents in given collection with given filters" do
    %{changes: changes} = Channels.Model.DataType.Site.changeset(@fields)
    {status, _} = Channels.Model.Repos.Site.create(changes)
    assert status === :ok
    {status, results} = Channels.Model.Repos.Site.all(%{name: "My Site"})
    assert status === :ok
    assert length(results) === 1
    {status, []} = Channels.Model.Repos.Site.all(%{"name" => "Saaa"})
    assert status === :ok
  end
end
