defmodule SowprojectWeb.PageController do
  use SowprojectWeb, :controller
  plug(:is_sign_in)

  def index(conn, _params) do
    render(conn, "index.html",
      questions:
        for question <-
              Sowproject.Repo.all(Sowproject.Features.Questions)
              |> Sowproject.Repo.preload(:options)
              |> Sowproject.Repo.preload(options: :features) do
          gen_question(question)
        end
    )
  end

  def gen_question(question) do
    %{
      promt: question.promt,
      answers: Enum.map(question.options, fn option -> option.value end),
      features:
        Enum.map(question.options, fn option ->
          if option.features do
            option.features.title
          else
            nil
          end
        end),
      hours:
        Enum.map(question.options, fn option ->
          if option.features do
            option.features.hours
          else
            nil
          end
        end),
      budget:
        Enum.map(question.options, fn option ->
          if option.features do
            option.features.budget
          else
            nil
          end
        end)
    }
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
