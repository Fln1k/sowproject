defmodule Sowproject.Features.Option do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}

  schema "options" do
    belongs_to(:variable, Sowproject.Features.Variable, type: :string)
    has_many(:options_features, Sowproject.Features.OptionsFeatures)
    has_many(:answers, Sowproject.Features.Answer)
    has_one(:feature, through: [:options_features, :feature])
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
