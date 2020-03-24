defmodule Sowproject.Repo.Migrations.CreateFeatures do
  use Ecto.Migration

  def change do
    create table(:features) do
      add(:parent_id, references(:features), null: true)
      add(:title, :string, null: false)
      add(:description_template, :string, null: false)
      add(:hours, :string, null: false)
      add(:budget, :string, null: false)
      add(:priority, :string, null: false)
      timestamps()
    end

  end
end
