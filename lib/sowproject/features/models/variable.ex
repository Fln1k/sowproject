defmodule Sowproject.Features.Variable do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "variables" do
    field(:name, :string)
    field(:question_prompt, :string)
    field(:type, Sowproject.EctoTypes.Atom)
    field(:default, :string)
    field(:priority, :string)

    has_many(:options, Sowproject.Features.Option)
    has_many(:answers, Sowproject.Features.Answer)
    has_many(:keywords_variables, Sowproject.Features.KeywordsVariable)

    timestamps()
  end

  @types ~w[int text radio checkbox]a
  @required_fields ~w(name question_prompt type default priority)a
  @doc false
  def changeset(variable, attrs) do
    variable
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:type, @types)
  end
end
