defmodule SowprojectWeb.PageController do
  require Ecto.Query
  use SowprojectWeb, :controller

  alias Ecto.Query
  alias Sowproject.Features.Keyword, as: Keywords
  alias SowprojectWeb.FeaturesController

  plug(:is_sign_in)

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    render(conn, "index.html", prepare_variables(current_user))
  end

  def prepare_variables(current_user) do
    keywords = Keywords.search(current_user.project_description)

    # shitcode
    {kfeatures, unconfirmed_kfeatures} =
      keywords
      |> Enum.flat_map(fn v -> v.keywords_features end)
      |> Sowproject.Features.filter(fn fk ->
        fk.weight && !String.match?(fk.feature.description_template, ~r/\{.*\}/)
      end)

    # shitcode
    kfeatures
    |> Enum.each(fn v ->
      feature = v.feature

      features =
        feature
        |> Sowproject.Features.Feature.ancestors()
        |> Sowproject.Repo.all()
        |> Enum.concat([feature])

      Enum.reduce(features, nil, fn feature, parent ->
        FeaturesController.find_result_by_feature(feature.id, current_user.id) ||
          FeaturesController.create_result_by_feature_and_parent(feature, parent, current_user.id)
      end)
    end)

    variables_ids = keywords |> Enum.flat_map(fn v -> Enum.map(v.keywords_variables, fn r -> r.variable_id end) end)

    fids =
      Query.from(
        v in Sowproject.Features.Variable,
        left_join: opt in assoc(v, :options),
        left_join: f in assoc(opt, :feature),
        where: v.id in ^variables_ids,
        select: {f.id, f.parent_id}
      )
      |> Sowproject.Repo.all()
      |> Enum.map(&Tuple.to_list/1)
      |> List.flatten()
      |> Enum.filter(&(!is_nil(&1)))
      |> Enum.uniq()
      |> Enum.sort()

    [
      variables:
        Query.from(
          v in Sowproject.Features.Variable,
          left_join: fe in Sowproject.Features.Feature,
          on: fe.id in ^fids,
          left_join: answ in Sowproject.Features.Answer,
          on: v.id == answ.variable_id and answ.user_id == ^current_user.id,
          left_join: opt in assoc(v, :options),
          left_join: f in assoc(opt, :feature),
          where: v.id in ^variables_ids or fragment("? LIKE '%{' || ? || '}%'", fe.description_template, v.id),
          preload: [answers: answ, options: {opt, [feature: f]}]
        )
        |> Sowproject.Repo.all()
        |> Enum.map(&gen_question/1),
      features:
        Sowproject.Features.Feature
        |> Sowproject.Repo.all()
        |> Enum.map(&gen_feature/1),
      confirmed_features: gen_features(kfeatures),
      unconfirmed_features: gen_features(unconfirmed_kfeatures),
      project_title: current_user.project_title,
      project_description: current_user.project_description,
      results:
        Sowproject.Repo.all(
          Query.from(
            r in Sowproject.Features.Result,
            where: r.user_id == ^current_user.id,
            preload: :parent
          )
        )
    ]
  end

  def reset_project(conn, _params) do
    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(
      :delete_user_results,
      Query.from(
        r in Sowproject.Features.Result,
        where: r.user_id == ^conn.assigns[:current_user].id
      )
    )
    |> Ecto.Multi.delete_all(
      :delete_user_answers,
      Query.from(
        a in Sowproject.Features.Answer,
        where: a.user_id == ^conn.assigns[:current_user].id
      )
    )
    |> Ecto.Multi.update(
      :remove_project_fields_from_user,
      Ecto.Changeset.change(
        conn.assigns[:current_user],
        project_title: nil,
        project_description: nil
      )
    )
    |> Sowproject.Repo.transaction()

    send_resp(conn, 200, "OK")
  end

  defp gen_question(variable) do
    answer = List.first(variable.answers)

    %{
      id: variable.id,
      promt: variable.question_prompt,
      options:
        Enum.map(variable.options, fn option ->
          %{
            id: option.id,
            value: option.value,
            feature:
              if option.feature do
                %{
                  id: option.feature.id,
                  parent_id: option.feature.parent_id,
                  title: option.feature.title,
                  hours: option.feature.hours,
                  budget: option.feature.budget,
                  description_template: option.feature.description_template
                }
              end
          }
        end),
      answer:
        if answer do
          %{
            id: answer.id,
            option_id: Map.get(answer, :option_id),
            answer: Map.get(answer, :answer)
          }
        end
    }
  end

  defp gen_feature(feature) do
    %{
      id: feature.id,
      parent_id: feature.parent_id,
      title: feature.title,
      hours: feature.hours,
      budget: feature.budget,
      description_template: feature.description_template
    }
  end

  def gen_features(kfeatures) do
    kfeatures
    |> Enum.group_by(& &1.feature_id)
    |> Enum.map(fn {_, features} ->
      features
      |> List.first()
      |> Map.get(:feature)
      |> gen_feature()
      |> Map.put(:weight, Enum.map(features, fn r -> r.weight end) |> Enum.sum())
    end)
  end

  def is_sign_in(conn, _params) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt
    end
  end
end
