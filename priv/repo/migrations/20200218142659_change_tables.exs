defmodule Sowproject.Repo.Migrations.ChangeTables do
  use Ecto.Migration

  def change do
    rename table(:questions), to: table(:variables)
    rename table(:keywords_question_triggers), to: table(:keywords_variables)

    rename table(:variables), :promt, to: :question_prompt
    rename table(:options), :questions_id, to: :variables_id
    
    drop table(:feature_question_triggers)
    
    alter table(:variables) do
      add(:name, :string, null: false)
    end

    alter table(:features) do
      add(:blocking, :string, null: false)
    end

    alter table(:keywords_variables) do
      add(:weight, :int, null: false)
    end

    alter table(:keywords_features) do
      add(:weight, :int, null: false)
    end

    alter table(:options_features) do
      add(:weight, :int, null: false)
    end
  end
end
