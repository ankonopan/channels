defmodule Channels.Model.UseCase.User do
  alias __MODULE__
  alias Channels.Model.Repos
  alias Channels.Model.DataType, as: Type

  @type user :: %Type.User{}

  @spec create(map) :: {:ok, user} | {:error, any}
  def create(params) do
    case Type.User.changeset(%Type.User{}, params) do
      %{valid?: true, changes: changes} ->
        Repos.User.create(changes)
      %{valid?: false, errors:  errors} ->
        {:error, [{:user, errors}]}
    end
  end
end
