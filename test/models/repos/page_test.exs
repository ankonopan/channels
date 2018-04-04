defmodule Channels.Model.Repos.PageTest do
  use ChannelsWeb.ConnCase
  @fields  %{title: "Muu", meta_title: "Muu", content: "Muu"}

  setup do
    Mongo.delete_many(:mongo, "pages", %{})
    :ok
  end

  test "Create a record on given db" do
    %{changes: changes} = Channels.Model.Page.changeset(@fields)
    {status, _} = Channels.Model.Repos.Page.create(changes)
    assert status === :ok
  end

  test "Update mongo db with given changeset" do
    %{changes: changes} = Channels.Model.Page.changeset(@fields)
    {:ok, %{"id" => id}} = Channels.Model.Repos.Page.create(changes)

    {status, record} = Channels.Model.Repos.Page.find(id)

    new_field = %{"title" => "Sa"}

    %{changes: changes} = Channels.Model.Page.changeset(Map.merge(record, new_field))

    {status, %{"title" => title}} = Channels.Model.Repos.Page.update(id, changes)

    assert status === :ok
    assert title === "Sa"
  end

  test "Find a document on the collection" do
    %{changes: changes} = Channels.Model.Page.changeset(@fields)
    {_, %{"id" => id}} = Channels.Model.Repos.Page.create(changes)

    {status, _} = Channels.Model.Repos.Page.find(id)
    assert status === :ok
  end

  test "Find all documents in given collection" do
    %{changes: changes} = Channels.Model.Page.changeset(@fields)
    Channels.Model.Repos.Page.create(changes)

    {status, list} = Channels.Model.Repos.Page.all()
    assert status === :ok
    assert length(list) === 1
  end

  test "Find all documents in given collection with given filters" do
    %{changes: changes} = Channels.Model.Page.changeset(@fields)
    {status, _} = Channels.Model.Repos.Page.create(changes)
    assert status === :ok
    {status, results} = Channels.Model.Repos.Page.all(%{title: "Muu"})
    assert status === :ok
    assert length(results) === 1
    {status, []} = Channels.Model.Repos.Page.all(%{"title" => "Saaa"})
    assert status === :ok
  end
end
