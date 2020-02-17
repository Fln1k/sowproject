defmodule Sowproject.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:password, :string)

    timestamps()
  end

  @required_fields ~w(email)a
  @optional_fields ~w()a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, ~w(password)a, [])
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(
          changeset,
          :password,
          Comeonin.Bcrypt.hashpwsalt(password)
        )

      _ ->
        changeset
    end
  end

  def gen_token(email) do
    password =
      Comeonin.Bcrypt.hashpwsalt(
        Sowproject.Repo.get_by(Sowproject.Accounts.User, %{email: email}).password
      )

    token = Base.encode64("#{email}&#{password}")
  end

  @spec decode_token(binary) :: :error | [binary]
  def decode_token(token) do
    case Base.decode64(token) do
      {:ok, decode_params} ->
        String.split(decode_params, "&")

      :error ->
        :error
    end
  end
end
