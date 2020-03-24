defmodule Sowproject.Features.Result do
  use Ecto.Schema
  use Arbor.Tree, foreign_key_type: :binary_id
  import Ecto.Changeset

  schema "results" do
    belongs_to(:parent, __MODULE__)
    belongs_to(:feature, Sowproject.Features.Feature)
    belongs_to(:user, Sowproject.Accounts.User)
    field(:title, :string)
    field(:description_template, :string)
    field(:hours, :float)
    field(:budget, :float)
    field(:priority, :string)
    timestamps()
  end

  @required_fields ~w(user_id feature_id title description_template)a
  @optional_fields ~w(hours budget priority parent_id)a

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:feature_id, name: :unique_result)
  end
end
