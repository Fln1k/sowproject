defmodule Sowproject.Features.Feature do
  use Ecto.Schema
  use Arbor.Tree, foreign_key_type: :id
  import Ecto.Changeset

  schema "features" do
    belongs_to(:parent, __MODULE__)
    field(:title, :string)
    field(:description_template, :string)
    field(:hours, :float)
    field(:budget, :float)
    field(:priority, :string)
    field(:blocking, :string)
    has_many(:options_features, Sowproject.Features.OptionsFeatures)
    has_many(:keywords_features, Sowproject.Features.KeywordsFeatures)
    has_many(:results, Sowproject.Features.Result)
    timestamps()
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [])
    |> validate_required([])
  end
end
