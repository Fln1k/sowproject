defmodule Sowproject.Features.FeatureQuestionTriggers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feature_question_triggers" do
    belongs_to(:questions, Sowproject.Features.Questions, type: :id)
    belongs_to(:features, Sowproject.Features.Features, type: :id)
    timestamps()
  end

  @doc false
  def changeset(feature_question_triggers, attrs) do
    feature_question_triggers
    |> cast(attrs, [])
    |> validate_required([])
  end
end
