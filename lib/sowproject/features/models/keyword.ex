defmodule Sowproject.Features.Keyword do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query

  alias Ecto.Query
  alias Sowproject.Repo

  @primary_key {:id, :string, []}
  schema "keywords" do
    has_many(:keywords_features, Sowproject.Features.KeywordsFeatures)
    has_many(:keywords_variables, Sowproject.Features.KeywordsVariables)
    field(:word_template, :string)
    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [])
    |> validate_required([])
  end

  def search(nil), do: []
  def search(""), do: []

  def search(text) do
    search_query(text) |> Repo.all()
  end

  def search_query(text) do
    Query.from(
      keyword in Sowproject.Features.Keyword,
      left_join: kf in assoc(keyword, :keywords_features),
      left_join: kv in assoc(keyword, :keywords_variables),
      where: fragment("? @@ plainto_tsquery(?)", ^text, keyword.id),
      preload: [keywords_features: {kf, :feature}, keywords_variables: {kv, :variable}]
    )
  end
end
