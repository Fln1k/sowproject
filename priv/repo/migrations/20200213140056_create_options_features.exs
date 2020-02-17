defmodule Sowproject.Repo.Migrations.CreateOptionsFeatures do
  use Ecto.Migration

  def change do
    create table(:options_features) do
      add(:options_id, references(:options, type: :id, on_delete: :delete_all), null: false)
      add(:features_id, references(:features, type: :id, on_delete: :delete_all), null: false)
      timestamps()
    end

  end
end
