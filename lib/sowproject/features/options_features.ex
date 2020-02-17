defmodule Sowproject.Features.OptionsFeatures do
  use Ecto.Schema
  import Ecto.Changeset

  schema "options_features" do
    belongs_to(:options, Sowproject.Features.Options, type: :id)
    belongs_to(:features, Sowproject.Features.Features, type: :id)
    timestamps()
  end

  @doc false
  def changeset(options_features, attrs) do
    options_features
    |> cast(attrs, [])
    |> validate_required([])
  end
end
