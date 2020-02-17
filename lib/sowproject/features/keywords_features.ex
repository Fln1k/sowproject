defmodule Sowproject.Features.KeywordsFeatures do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords_features" do
    belongs_to(:features, Sowproject.Features.Features, type: :id)
    belongs_to(:keywords, Sowproject.Features.Keywords, type: :id)
    timestamps()
  end

  @doc false
  def changeset(keywords_features, attrs) do
    keywords_features
    |> cast(attrs, [])
    |> validate_required([])
  end
end
