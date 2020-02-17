defmodule Sowproject.Features.Keywords do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords" do
    field(:word_template, :string)
    timestamps()
  end

  @doc false
  def changeset(keywords, attrs) do
    keywords
    |> cast(attrs, [])
    |> validate_required([])
  end
end
