defmodule Sowproject.Repo.Migrations.CreateFeatureQuestionTriggers do
  use Ecto.Migration

  def change do
    create table(:feature_question_triggers) do
      add(:questions_id, references(:questions, type: :id, on_delete: :delete_all), null: false)
      add(:features_id, references(:features, type: :id, on_delete: :delete_all), null: false)
      timestamps()
    end

  end
end
