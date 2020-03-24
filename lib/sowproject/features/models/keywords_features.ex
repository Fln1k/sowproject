defmodule Sowproject.Features.KeywordsFeatures do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords_features" do
    belongs_to(:feature, Sowproject.Features.Feature)
    belongs_to(:keyword, Sowproject.Features.Keyword, type: :string)
    field(:weight, :integer)
    timestamps()
  end

  @doc false
  def changeset(keywords_features, attrs) do
    keywords_features
    |> cast(attrs, [])
    |> validate_required([])
  end
end
