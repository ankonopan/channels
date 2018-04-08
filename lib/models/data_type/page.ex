defmodule Channels.Model.DataType.Page do
  alias __MODULE__
  use ChannelsWeb, :document
  require Logger

  @type page :: __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}  # the id maps to uuid
  schema "pages" do
    field :title,       :string
    field :content,     :string

    field :url,           :string
    field :language_code, :string
    field :page_layout,   :string

    field :locked_by_id,  :string # reference to an User id as string
    field :creator_id,    :string # reference to an User id as string
    field :updater_id,    :string # reference to an User id as string

    field :visible,      :boolean, default: false
    field :restricted,   :boolean, default: false
    field :robot_index,  :boolean, default: false
    field :robot_follow, :boolean, default: false
    field :sitemap,      :boolean, default: false

    field :published_at, :utc_datetime
    field :public_on,    :utc_datetime
    field :public_until, :utc_datetime
    field :locked_at,    :utc_datetime

    field :tags, {:array, :string}

    # Page 1 -> * Cells 1 -> * Elements
    # %Cell{
    #   name: "Shuu",
    #   elements: [
    #     %Element{type: "Issue", value: ""}
    #     ]}
    field :cells, {:array, :list}


    field :meta_title,        :string
    field :meta_keywords,     :string
    field :meta_description,  :string

    field :lft,       :integer
    field :rgt,       :integer
    field :parent_id, :binary_id
    field :depth,     :integer

    timestamps()
  end

  @doc """
  Convert a Map into a changeset for MongoDB manipulation


  """
  @allowed_params [:title, :content, :creator_id]
  @optional_params [:meta_title, :meta_keywords, :meta_description]
  @required_params [:title, :content, :creator_id]

  @spec changeset(page, map) :: page
  def changeset(page \\ %Page{}, params) do
    page
      |> cast(params, @allowed_params, @optional_params)
      |> validate_required(@required_params)
      |> validate_change(:locked_by_id, &Channels.Utils.User.Validator.valid?/2)
      |> validate_change(:creator_id, &Channels.Utils.User.Validator.valid?/2)
      |> validate_change(:updater_id, &Channels.Utils.User.Validator.valid?/2)
  end
end
