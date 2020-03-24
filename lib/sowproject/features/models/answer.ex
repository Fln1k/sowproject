defmodule Sowproject.Features.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    belongs_to(:user, Sowproject.Accounts.User)
    belongs_to(:variable, Sowproject.Features.Variable, type: :string)
    belongs_to(:option, Sowproject.Features.Option, type: :string)
    field(:answer, :string)
    timestamps()
  end

  @required_fields ~w(user_id variable_id)a
  @optional_fields ~w(option_id answer)a

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
