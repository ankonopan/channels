defmodule Channels.Model.UseCase.Site do
  alias __MODULE__
  use Channels.Model

  @spec create(map) :: {:ok, site} | {:error, any}
  def create(params) do
    case Type.Site.changeset(%Type.Site{}, params) do
      %{valid?: true, changes: changes} ->
        Repo.Site.create(changes)
      %{valid?: false, errors: errors} ->
        {:error, [{:page, errors}]}
    end
  end
end
