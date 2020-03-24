defmodule Sowproject.Database do
  # Sowproject.Database.fill_via_json("export.json")
  defp gen_variable(variable) do
    naive_datetime = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    %{
      id: variable.variable,
      question_prompt: variable.prompt,
      name: variable.variable,
      type: String.to_atom(variable.type),
      default: to_string(variable.default),
      priority: "1",
      inserted_at: naive_datetime,
      updated_at: naive_datetime
    }
  end

  defp gen_feature(feature) do
    naive_datetime = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    %{
      id: feature.id,
      parent_id:
        if feature.parent_id > 0 do
          feature.parent_id
        end,
      title: feature.title,
      description_template: feature.body,
      hours: feature.time,
      budget: feature.budget,
      priority: "1",
      blocking: "false",
      inserted_at: naive_datetime,
      updated_at: naive_datetime
    }
  end

  defp gen_options(variable) do
    naive_datetime = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    if variable.options do
      Enum.map(variable.options, fn option ->
        %{
          id: variable.variable <> option,
          variable_id: variable.variable,
          value: option,
          inserted_at: naive_datetime,
          updated_at: naive_datetime
        }
      end)
    end
  end

  defp gen_options_features(option_feature) do
    naive_datetime = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    %{
      option_id: option_feature.variable <> option_feature.answer,
      feature_id: option_feature.feature,
      weight: option_feature.weight,
      inserted_at: naive_datetime,
      updated_at: naive_datetime
    }
  end

  defp gen_keyword(data_with_keyword) do
    naive_datetime = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    %{
      id: data_with_keyword.keyword,
      word_template: data_with_keyword.keyword,
      inserted_at: naive_datetime,
      updated_at: naive_datetime
    }
  end

  defp gen_keyword_variables(keyword_variable) do
    naive_datetime = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    %{
      keyword_id: keyword_variable.keyword,
      variable_id: keyword_variable.variable,
      weight: keyword_variable.weight,
      inserted_at: naive_datetime,
      updated_at: naive_datetime
    }
  end

  defp gen_keyword_features(keyword_feature) do
    naive_datetime = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    %{
      keyword_id: keyword_feature.keyword,
      feature_id: keyword_feature.feature,
      weight: keyword_feature.weight,
      inserted_at: naive_datetime,
      updated_at: naive_datetime
    }
  end

  def fill_via_json(path) do
    data =
      path
      |> File.read!()
      |> Poison.Parser.parse!(%{keys: :atoms})

    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(
      :delete_all_results,
      Sowproject.Features.Result
    )
    |> Ecto.Multi.delete_all(
      :delete_all_keywords_features,
      Sowproject.Features.KeywordsFeatures
    )
    |> Ecto.Multi.delete_all(
      :delete_all_keywords_variables,
      Sowproject.Features.KeywordsVariables
    )
    |> Ecto.Multi.delete_all(
      :delete_all_keywords,
      Sowproject.Features.Keyword
    )
    |> Ecto.Multi.delete_all(
      :delete_all_options_features,
      Sowproject.Features.OptionsFeatures
    )
    |> Ecto.Multi.delete_all(
      :delete_all_features,
      Sowproject.Features.Feature
    )
    |> Ecto.Multi.delete_all(
      :delete_all_options,
      Sowproject.Features.Option
    )
    |> Ecto.Multi.delete_all(
      :delete_all_variables,
      Sowproject.Features.Variable
    )
    |> Ecto.Multi.insert_all(
      :variables,
      Sowproject.Features.Variable,
      Enum.map(data.variables, &gen_variable/1)
    )
    |> Ecto.Multi.insert_all(
      :options,
      Sowproject.Features.Option,
      data.variables
      |> Enum.map(&gen_options/1)
      |> List.flatten()
      |> Enum.reject(&is_nil/1)
    )
    |> Ecto.Multi.insert_all(
      :features,
      Sowproject.Features.Feature,
      Enum.map(data.features, &gen_feature/1)
    )
    |> Ecto.Multi.insert_all(
      :options_features,
      Sowproject.Features.OptionsFeatures,
      Enum.map(data.answers, &gen_options_features/1)
    )
    |> Ecto.Multi.insert_all(
      :keywords,
      Sowproject.Features.Keyword,
      Enum.uniq_by(
        Enum.map(data.keyword_variables, &gen_keyword/1) ++ Enum.map(data.keyword_features, &gen_keyword/1),
        fn keyword -> keyword.id end
      )
    )
    |> Ecto.Multi.insert_all(
      :keywords_variables,
      Sowproject.Features.KeywordsVariables,
      Enum.map(data.keyword_variables, &gen_keyword_variables/1)
    )
    |> Ecto.Multi.insert_all(
      :keywords_features,
      Sowproject.Features.KeywordsFeatures,
      Enum.map(data.keyword_features, &gen_keyword_features/1)
    )
    |> Sowproject.Repo.transaction()
  end
end
