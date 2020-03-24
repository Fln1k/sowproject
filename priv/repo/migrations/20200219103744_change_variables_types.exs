defmodule Sowproject.Repo.Migrations.ChangeTablesIdsAndReferancesFKeys do
  use Ecto.Migration

  def change do
    execute("""
    ALTER TABLE variables DROP CONSTRAINT questions_pkey CASCADE;
    """)

    execute("""
    ALTER TABLE options DROP CONSTRAINT options_pkey CASCADE;
    """)

    execute("""
    ALTER TABLE keywords DROP CONSTRAINT keywords_pkey CASCADE;
    """)

    rename(table(:answers), :questions_id, to: :variable_id)
    rename(table(:answers), :options_id, to: :option_id)
    rename(table(:keywords_features), :features_id, to: :feature_id)
    rename(table(:keywords_features), :keywords_id, to: :keyword_id)
    rename(table(:keywords_variables), :questions_id, to: :variable_id)
    rename(table(:keywords_variables), :keywords_id, to: :keyword_id)
    rename(table(:options), :variables_id, to: :variable_id)
    rename(table(:options_features), :features_id, to: :feature_id)
    rename(table(:options_features), :options_id, to: :option_id)
    rename(table(:result), :features_id, to: :feature_id)

    alter table(:variables) do
      modify(:id, :string, primary_key: true)
    end

    alter table(:options) do
      modify(:id, :string, primary_key: true)

      modify(:variable_id, references(:variables, type: :string, on_delete: :delete_all),
        null: false
      )
    end

    alter table(:options_features) do
      modify(:option_id, references(:options, type: :string, on_delete: :delete_all), null: false)
    end

    alter table(:keywords) do
      modify(:id, :string, primary_key: true)
    end

    alter table(:keywords_variables) do
      modify(:variable_id, references(:variables, type: :string, on_delete: :delete_all),
        null: false
      )

      modify(:keyword_id, references(:keywords, type: :string, on_delete: :delete_all),
        null: false
      )
    end

    alter table(:keywords_features) do
      modify(:keyword_id, references(:keywords, type: :string, on_delete: :delete_all),
        null: false
      )
    end

    drop(constraint(:variables, :type_must_be_valid))
    create(constraint(:variables, :type_must_be_valid, check: "type in ('int', 'text', 'radio')"))

    create(
      unique_index(:keywords_features, [:keyword_id, :feature_id], name: :keywords_features_fkeys)
    )

    create(
      unique_index(:keywords_variables, [:keyword_id, :variable_id],
        name: :keywords_variables_fkeys
      )
    )

    create(
      unique_index(:options_features, [:option_id, :feature_id], name: :options_features_fkeys)
    )

    create(unique_index(:keywords, :word_template, name: :word_template))

    rename(table(:variables), to: table(:variable))
    rename(table(:options), to: table(:option))
    rename(table(:answers), to: table(:answer))
    rename(table(:features), to: table(:feature))
    rename(table(:keywords), to: table(:keyword))
  end
end
