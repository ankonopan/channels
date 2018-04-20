defmodule Channels.Model.UseCase.Page do
  alias __MODULE__
  use Channels.Model

  @doc """

  """
  @spec create({site, map, user}) :: {:ok, page} | {:error, any}
  def create({site, params, creator}) do
    changeset = Type.Page.changeset(Map.merge(params, %{creator_id: creator.id}))

    case changeset do
      %{valid?: true, changes: changes} ->
        Repo.Page.create(site, Type.Page.dump(changeset))
      _ ->
        {:error, [{:page, "invalid"}, changeset]}
    end
  end
end
