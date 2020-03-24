defmodule Sowproject.Features.OptionsFeatures do
  use Ecto.Schema
  import Ecto.Changeset

  schema "options_features" do
    belongs_to(:option, Sowproject.Features.Option, type: :string)
    belongs_to(:feature, Sowproject.Features.Feature)
    field(:weight, :integer)
    timestamps()
  end

  @doc false
  def changeset(options_features, attrs) do
    options_features
    |> cast(attrs, [])
    |> validate_required([])
  end
end
