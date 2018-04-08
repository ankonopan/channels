defmodule Channels.Model do
  @doc """
  Makes available data type definitions and aliases to submodules that use this module.
  Normally it will be the submodules of this module.

  ## Example
    defmodule Channels.Model.DataType.NewType do
      use Channels.Model
    end
  """
   defmacro __using__(_params) do
    quote do
      @type site :: DataType.Site
      @type page :: DataType.Page
      @type user :: DataType.User

      @type result :: {:ok, map} | {:error, String.t} | {:ok, integer}
      @type results :: {:ok, list(map)} | {:error, String.t}

      alias Channels.Model.DataType, as: Type
      alias Channels.Model.Repo, as: Repo
      alias Channels.Model.DataType.Validator, as: Validator
    end
  end
end
