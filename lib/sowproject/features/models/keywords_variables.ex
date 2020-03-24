defmodule Sowproject.Features.KeywordsVariables do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords_variables" do
    belongs_to(:variable, Sowproject.Features.Variable, type: :string)
    belongs_to(:keyword, Sowproject.Features.Keyword, type: :string)
    field(:weight, :integer)
    timestamps()
  end

  @doc false
  def changeset(keywords_variables, attrs) do
    keywords_variables
    |> cast(attrs, [])
    |> validate_required([])
  end
end
