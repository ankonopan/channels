defmodule ChannelsWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ChannelsWeb, :controller
      use ChannelsWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ChannelsWeb
      import Plug.Conn
      import ChannelsWeb.Router.Helpers
      import ChannelsWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/channels_web/templates",
                        namespace: ChannelsWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import ChannelsWeb.Router.Helpers
      import ChannelsWeb.ErrorHelpers
      import ChannelsWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ChannelsWeb.Gettext
    end
  end

  def document do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
