defmodule Sowproject.Repo.Migrations.CreateKeywordsFeatures do
  use Ecto.Migration

  def change do
    create table(:keywords_features) do
      add(:features_id, references(:features, type: :id, on_delete: :delete_all), null: false)
      add(:keywords_id, references(:keywords, type: :id, on_delete: :delete_all), null: false)
      timestamps()
    end

  end
end
