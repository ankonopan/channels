defmodule Channels.Model.UseCase.User do
  alias __MODULE__
  use Channels.Model

  @spec create(map) :: {:ok, user} | {:error, any}
  def create(params) do
    case Type.User.changeset(%Type.User{}, params) do
      %{valid?: true, changes: changes} ->
        Repo.User.create(changes)
      %{valid?: false, errors:  errors} ->
        {:error, [{:user, errors}]}
    end
  end
end
