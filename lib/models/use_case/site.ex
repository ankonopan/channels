defmodule Channels.Model.UseCase.Site do
  alias __MODULE__
  alias Channels.Model.Repos
  alias Channels.Model.DataType, as: Type

  @type site :: %Type.Site{}

  @spec create(map) :: {:ok, site} | {:error, any}
  def create(params) do
    case Type.Site.changeset(%Type.Site{}, params) do
      %{valid?: true, changes: changes} ->
        Repos.Site.create(changes)
      %{valid?: false, errors: errors} ->
        {:error, [{:page, errors}]}
    end
  end
end
