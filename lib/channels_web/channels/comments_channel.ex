defmodule Channels.CommentsChannel do
  use ChannelsWeb, :channel

  def join("comments:" <> topic_id, _params, socket) do
    {:ok, %{}, socket}
  end

  def handle_in() do

  end
end
