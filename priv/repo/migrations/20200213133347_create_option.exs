defmodule Sowproject.Repo.Migrations.CreateOptions do
  use Ecto.Migration

  def change do
    create table(:options) do
      add(:value, :string, null: false)
      add(:questions_id, references(:questions, type: :id, on_delete: :delete_all), null: false)
      timestamps()
    end

  end
end
