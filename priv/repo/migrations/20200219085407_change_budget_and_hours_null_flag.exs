defmodule Sowproject.Repo.Migrations.ChangeBudgetAndHoursNullFlag do
  use Ecto.Migration

  use Ecto.Migration

  def change do
    execute("""
     alter table result alter column budget type float using (budget::float)
    """)

    execute("""
     alter table result alter column hours type float using (hours::float)
    """)

    alter table(:result) do
      modify(:hours, :float, null: true)
      modify(:budget, :float, null: true)
    end

    execute("""
     alter table features alter column budget type float using (budget::float)
    """)

    execute("""
     alter table features alter column hours type float using (hours::float)
    """)

    alter table(:features) do
      modify(:hours, :float, null: true)
      modify(:budget, :float, null: true)
    end
  end
end
