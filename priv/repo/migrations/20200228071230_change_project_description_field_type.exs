defmodule Sowproject.Repo.Migrations.ChangeProjectDescriptionFieldType do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify(:project_description, :text, null: true)
    end

    create(unique_index(:results, [:user_id, :feature_id], name: :unique_result))
  end
end
