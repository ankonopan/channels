defmodule Channels.Model.Repo.PageTest do
  alias __MODULE__
  use Channels.Model
  use ChannelsWeb.ConnCase

  @fields   %{title: "Muu", meta_title: "Muu", content: "Muu"}
  @site     %Type.Site{id: "43lkj34", name: "Some Site", host: "www.someplace.com"}

  def create_page(site, fields) do
    %{changes: changes} = Type.Page.changeset(%Type.Page{}, fields)
    site |> Repo.Page.create(changes)
  end

  setup do
    Mongo.delete_many(:mongo, Repo.Page.collection(@site), %{})
    :ok
  end

  test "Create a record on given db" do
    {status, _} = create_page(@site, @fields)
    assert status === :ok
  end

  test "Update mongo db with given changeset" do
    {:ok, %{id: id}} =  create_page(@site, @fields)
    {:ok, record} = @site |> Repo.Page.find(id)

    %{changes: changes} = record |> Type.Page.changeset(%{"title" => "Sa"})

    {status, %{title: title}} = @site |> Repo.Page.update(id, changes)

    assert status === :ok
    assert title === "Sa"
  end

  test "Find a document on the collection" do
    {_, %{id: id}} = create_page(@site, @fields)

    {status, _} = @site |> Repo.Page.find(id)
    assert status === :ok
  end

  test "Find all documents in given collection" do
    create_page(@site, @fields)

    {status, list} = @site |> Repo.Page.all()
    assert status === :ok
    assert length(list) === 1
  end

  test "Find all documents in given collection with given filters" do
    {status, _} =  create_page(@site, @fields)
    assert status === :ok
    {status, results} = @site |> Repo.Page.all(%{title: "Muu"})
    assert status === :ok
    assert length(results) === 1
    {status, []} = @site |> Repo.Page.all(%{"title" => "Saaa"})
    assert status === :ok
  end
end
