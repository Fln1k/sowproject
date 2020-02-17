defmodule Sowproject.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add(:user_id, references(:users, type: :id, on_delete: :delete_all), null: false)
      add(:questions_id, references(:questions, type: :id, on_delete: :delete_all), null: false)
      add(:options_id, references(:options, type: :id, on_delete: :delete_all), null: true)
      add(:answer, :string, null: false)
      add(:value, :string, null: false)
      timestamps()
    end

  end
end
