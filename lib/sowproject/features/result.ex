defmodule Sowproject.Features.Result do
  use Ecto.Schema
  use Arbor.Tree, foreign_key_type: :binary_id
  import Ecto.Changeset

  schema "result" do
    belongs_to(:parent, __MODULE__)
    belongs_to(:features, Sowproject.Features.Features, type: :id)
    belongs_to(:users, Sowproject.Accounts.User, type: :id)
    field(:title, :string)
    field(:description_template, :string)
    field(:hours, :string)
    field(:budget, :string)
    field(:priority, :string)
    timestamps()
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, [])
    |> validate_required([])
  end
end
