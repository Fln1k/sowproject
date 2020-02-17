defmodule Sowproject.Repo.Migrations.ChangeParentsRelations do
  use Ecto.Migration

  def change do
    drop(constraint(:result, :result_parent_id_fkey))
    alter table(:result) do
      modify(:parent_id, references(:result, on_delete: :delete_all), null: true)
    end
    drop(constraint(:features, :features_parent_id_fkey))
    alter table(:features) do
      modify(:parent_id, references(:features, on_delete: :delete_all), null: true)
    end
  end
end
