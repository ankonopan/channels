defmodule Channels.Model.Repo.SiteTest do
  alias __MODULE__
  use Channels.Model
  use ChannelsWeb.ConnCase


  def create_site(fields) do
    %{changes: changes} = Type.Site.changeset(%Type.Site{}, fields)
    Repo.Site.create(changes)
  end

  setup do
    Mongo.delete_many(Repo.Site.connection, Repo.Site.collection, %{})

    %{fields: %{name: "My Site", host: "www.somehost.com", id: "3sf393fa3f"}}
  end

  test "Create a record on given db", %{fields: fields} do
    {status, _} = create_site(fields)
    assert status === :ok
  end

  test "Update mongo db with given changeset", %{fields: fields}  do
    {:ok, %{id: id}} = create_site(fields)

    {:ok, record} = Repo.Site.find(id)

    %{changes: changes} = record |> Type.Site.changeset(%{name: "Sa"})

    {status, %{name: name}} = Repo.Site.update(id, changes)

    assert status === :ok
    assert name === "Sa"
  end

  test "Find a document on the collection", %{fields: fields}  do
    {_, %{id: id}} = create_site(fields)

    {status, _} = Repo.Site.find(id)
    assert status === :ok
  end

  test "Find all documents in given collection", %{fields: fields}  do
    create_site(fields)

    {status, list} = Repo.Site.all()
    assert status === :ok
    assert length(list) === 1
  end

  test "Find all documents in given collection with given filters", %{fields: fields}  do
    {status, _} = create_site(fields)
    assert status === :ok
    {status, results} = Repo.Site.all(%{name: "My Site"})
    assert status === :ok
    assert length(results) === 1
    {status, []} = Repo.Site.all(%{"name" => "Saaa"})
    assert status === :ok
  end
end
