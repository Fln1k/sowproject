defmodule Sowproject.Repo.Migrations.AddNewVariableType do
  use Ecto.Migration

  def change do
    drop(constraint(:variable, :type_must_be_valid))

    create(
      constraint(:variable, :type_must_be_valid,
        check: "type in ('int', 'text', 'radio','checkbox')"
      )
    )

    alter table(:feature) do
      modify(:description_template, :text, null: false)
    end

    alter table(:result) do
      modify(:description_template, :text, null: false)
    end

    alter table(:variable) do
      modify(:question_prompt, :text, null: false)
    end

    rename(table(:variable), to: table(:variables))
    rename(table(:option), to: table(:options))
    rename(table(:answer), to: table(:answers))
    rename(table(:feature), to: table(:features))
    rename(table(:keyword), to: table(:keywords))
    rename(table(:result), to: table(:results))
  end
end
