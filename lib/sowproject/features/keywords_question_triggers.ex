defmodule Sowproject.Features.KeywordsQuestionTriggers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords_question_triggers" do
    belongs_to(:questions, Sowproject.Features.Questions, type: :id)
    belongs_to(:keywords, Sowproject.Features.Keywords, type: :id)
    timestamps()
  end

  @doc false
  def changeset(keywords_question_triggers, attrs) do
    keywords_question_triggers
    |> cast(attrs, [])
    |> validate_required([])
  end
end
