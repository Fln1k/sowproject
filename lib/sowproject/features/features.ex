defmodule Sowproject.Features do
  import Ecto.Query, warn: false
  alias Sowproject.Repo

  alias Sowproject.Features.{Answer, Result, Feature}

  @valid_weight 100

  def valid_weight, do: @valid_weight

  def create_answer(attrs \\ %{}) do
    Repo.transaction(fn ->
      user = Sowproject.Accounts.get_user_by_params(%{id: attrs["user_id"]})

      Sowproject.Accounts.update_user(user, %{project_description: "#{user.project_description}. #{attrs["answer"]}"})

      %Answer{}
      |> Answer.changeset(attrs)
      |> Repo.insert()
    end)
  end

  def create_result(attrs \\ %{}) do
    %Result{}
    |> Result.changeset(attrs)
    |> Repo.insert()
  end

  def update_result(%Result{} = result, attrs) do
    result
    |> Result.changeset(attrs)
    |> Repo.update()
  end

  def get_feature_by_params(params) do
    Repo.get_by(Feature, params)
  end

  def get_result_by_params(params) do
    Repo.get_by(Result, params)
  end

  def filter(values, filter \\ nil) do
    values
    |> Enum.reduce({[], []}, fn kf, {valid, invalid} ->
      result =
        if filter do
          filter.(kf)
        else
          kf.weight >= @valid_weight
        end

      if result do
        {valid ++ [kf], invalid}
      else
        {valid, invalid ++ [kf]}
      end
    end)
  end
end
