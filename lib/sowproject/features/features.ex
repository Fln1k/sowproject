defmodule Sowproject.Features.Features do
  use Ecto.Schema
  use Arbor.Tree, foreign_key_type: :id
  import Ecto.Changeset

  schema "features" do
    belongs_to(:parent, __MODULE__)
    field(:title, :string)
    field(:description_template, :string)
    field(:hours, :string)
    field(:budget, :string)
    field(:priority, :string)

    has_one(:options, Sowproject.Features.OptionsFeatures)
    timestamps()
  end

  @doc false
  def changeset(features, attrs) do
    features
    |> cast(attrs, [])
    |> validate_required([])
  end
end
