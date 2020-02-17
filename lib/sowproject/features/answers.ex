defmodule Sowproject.Features.Answers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    belongs_to(:users, Sowproject.Accounts.User, type: :id)
    belongs_to(:questions, Sowproject.Features.Questions, type: :id)
    belongs_to(:option_id, Sowproject.Features.Option, type: :id)
    field(:answer, :string)
    timestamps()
  end

  @doc false
  def changeset(answers, attrs) do
    answers
    |> cast(attrs, [])
    |> validate_required([])
  end
end
