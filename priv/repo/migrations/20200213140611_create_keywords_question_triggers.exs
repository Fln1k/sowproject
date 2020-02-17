defmodule Sowproject.Repo.Migrations.CreateKeywordsQuestionTriggers do
  use Ecto.Migration

  def change do
    create table(:keywords_question_triggers) do
      add(:questions_id, references(:questions, type: :id, on_delete: :delete_all), null: false)
      add(:keywords_id, references(:keywords, type: :id, on_delete: :delete_all), null: false)
      timestamps()
    end

  end
end
