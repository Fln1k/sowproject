defmodule Sowproject.Repo.Migrations.RemoveValueFieldFromAnswers do
  use Ecto.Migration

  def change do
    alter table(:answer) do
      modify(:answer, :string, null: true)
      remove(:value, :string, null: false)
      modify(:option_id, references(:option, type: :string, on_delete: :delete_all), null: true)

      modify(:variable_id, references(:variable, type: :string, on_delete: :delete_all),
        null: false
      )
    end
  end
end
