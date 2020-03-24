defmodule Sowproject.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table(:keywords) do
      add(:word_template, :string, null: false)
      timestamps()
    end

  end
end
