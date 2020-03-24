defmodule Sowproject.Repo.Migrations.ChangeUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:project_title, :string)
      add(:project_description, :string)
    end
  end
end
