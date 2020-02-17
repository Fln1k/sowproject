defmodule Sowproject.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add(:promt, :string, null: false)
      add(:type, :string, null: false)
      add(:default, :string, null: false)
      add(:priority, :string, null: false)
      timestamps()
    end

    create(constraint(:questions, :type_must_be_valid, check: "type in ('INT', 'TEXT', 'OPTIONS')"))
  end
end
