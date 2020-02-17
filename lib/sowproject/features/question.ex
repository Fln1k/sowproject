defmodule Sowproject.Features.Questions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field(:promt, :string)
    field(:type, Sowproject.EctoTypes.Atom)
    field(:default, :string)
    field(:priority, :string)

    has_many(:options, Sowproject.Features.Options)
    timestamps()
  end

  @types ~w[INT TEXT OPTIONS]a

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [])
    |> validate_required([])
    |> validate_inclusion(:type, @types)
  end
end
