defmodule SowprojectWeb.FeaturesController do
  use SowprojectWeb, :controller

  def callback_update_answer(conn, params) do
    Sowproject.Features.create_answer(params)

    response =
      conn.assigns[:current_user]
      |> SowprojectWeb.PageController.prepare_variables()
      |> Enum.into(%{})
      |> Poison.encode!()

    send_resp(conn, 201, response)
  end

  def callback_update_result(conn, params) do
    result = find_result_by_feature(params["id"], conn.assigns[:current_user].id)
    result = result || (create_action(conn, params) && find_result_by_feature(params["id"], conn.assigns[:current_user].id))

    Sowproject.Features.update_result(result, %{description_template: params["description_template"]})

    response =
      conn.assigns[:current_user]
      |> SowprojectWeb.PageController.prepare_variables()
      |> Enum.into(%{})
      |> Poison.encode!()

    send_resp(conn, 201, response)
  end

  def create_results(conn, params) do
    create_action(conn, params)

    response =
      conn.assigns[:current_user]
      |> SowprojectWeb.PageController.prepare_variables()
      |> Enum.into(%{})
      |> Poison.encode!()

    send_resp(conn, 201, response)
  end

  def find_result_by_feature(feature_id, user_id) do
    Sowproject.Features.get_result_by_params(%{
      feature_id: feature_id,
      user_id: user_id
    })
  end

  def create_action(conn, params) do
    feature = Sowproject.Features.get_feature_by_params(%{id: params["id"]})

    features =
      feature
      |> Sowproject.Features.Feature.ancestors()
      |> Sowproject.Repo.all()

    features = Enum.concat([feature], features) |> Enum.reverse()

    Enum.reduce(features, nil, fn feature, parent ->
      new_parent =
        find_result_by_feature(feature.id, conn.assigns[:current_user].id) ||
          SowprojectWeb.FeaturesController.create_result_by_feature_and_parent(feature, parent, conn.assigns[:current_user].id)

      new_parent
    end)
  end

  def create_result_by_feature_and_parent(feature, parent, user_id) do
    {:ok, result} =
      Sowproject.Features.create_result(%{
        user_id: user_id,
        feature_id: feature.id,
        parent_id:
          if parent do
            parent.id
          end,
        title: feature.title,
        description_template: feature.description_template,
        hours: feature.hours,
        budget: feature.budget,
        priority: feature.priority
      })

    result
  end
end
