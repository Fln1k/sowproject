defmodule Sowproject.EctoTypes.Atom do
  @behaviour Ecto.Type

  def type, do: :string

  def cast(str) when is_binary(str) do
    {:ok, String.to_atom(str)}
  end

  def cast(atom) when is_atom(atom) do
    {:ok, atom}
  end

  def cast(_), do: :error

  def load(str) when is_binary(str) do
    {:ok, String.to_atom(str)}
  end

  def dump(atom) when is_atom(atom) do
    {:ok, Atom.to_string(atom)}
  end

  def dump(_), do: :error
end
