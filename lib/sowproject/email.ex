defmodule Sowproject.Email do
  use Bamboo.Phoenix, view: SowprojectWeb.EmailView

  def welcome_text_email(email_address) do
    new_email()
    |> to(email_address)
    |> from("us@example.com")
    |> subject("Welcome!")
    |> put_text_layout({SowprojectWeb.EmailView, "email.text"})
    |> render("welcome.text")
  end

  def welcome_html_email(email_address) do
    email_address
    |> welcome_text_email()
    |> put_html_layout({SowprojectWeb.EmailView, "email.html"})
    |> render("welcome.html", email_address: email_address) # <= Assignments
  end
end
