defmodule Channels.Model.UseCase.Page do

  alias Channels.Model.Repos
  alias Channels.Model.DataType, as: Type

  @type site :: %Type.Site{}
  @type page :: %Type.Page{}
  @type user :: %Type.User{}

  @doc """

  ## Example
    iex> {:ok, user} = Channels.Model.UseCase.User.create(%{name: "Samuel", email: "sam@sam.com"})
    iex> {:ok, site} = Channels.Model.UseCase.Site.create(%{name: "SomeSite", host: "sam.com"})
    iex> {status, page} = Channels.Model.UseCase.Page.create({site, %{title: "Some Title", content: "Some Description"}, user})
    iex> status
    :ok
  """
  @spec create({site, map, user}) :: {:ok, page} | {:error, any}
  def create({site, params, creator}) do
    new_page = Type.Page.changeset(%Type.Page{}, Map.merge(params, %{creator_id: creator.id}))
    case new_page do
      %{valid?: true, changes: changes} ->
        Repos.Page.create(site, changes)
      _ ->
        {:error, [{:page, "invalid"}]}
    end
  end
end
