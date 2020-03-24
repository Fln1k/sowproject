defmodule Sowproject.Repo.Migrations.CreateResult do
  use Ecto.Migration

  def change do
    create table(:result) do
      add(:user_id, references(:users, type: :id, on_delete: :delete_all), null: false)
      add(:features_id, references(:features, type: :id, on_delete: :nilify_all), null: false)
      add(:parent_id, references(:result), null: true)
      add(:title, :string, null: false)
      add(:description_template, :string, null: false)
      add(:hours, :string, null: false)
      add(:budget, :string, null: false)
      add(:priority, :string, null: false)
      timestamps()
    end

  end
end
