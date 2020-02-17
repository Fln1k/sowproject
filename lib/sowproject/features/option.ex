defmodule Sowproject.Features.Options do
  use Ecto.Schema
  import Ecto.Changeset

  schema "options" do
    belongs_to(:questions, Sowproject.Features.Questions, type: :id)
    has_one(:options_features, Sowproject.Features.OptionsFeatures)
    has_one(:features, through: [:options_features, :features])
    field(:value, :string)
    timestamps()
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [])
    |> validate_required([])
  end
end
