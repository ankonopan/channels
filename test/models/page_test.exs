defmodule Channels.Model.Page do
  use ChannelsWeb.ConnCase

  describe "Creates or Updates records" do
    test "creates a record in db" do
      page = Channels.Model.Page.changeset(%Channels.Model.Page{}, %{title: "Muu", meta_title: "Muu", content: "Muu"})
      {status, record} = Channels.Model.Page.update_db(page.changes)
    end
  end
end
