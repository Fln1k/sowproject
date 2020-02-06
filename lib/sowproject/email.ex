defmodule Sowproject.Email do
  use Bamboo.Phoenix, view: SowprojectWeb.EmailView

  def welcome_text_email(email_address) do
    new_email()
    |> to(email_address)
    |> from("support@sowproject.com")
    |> subject("Welcome!")
    |> render("welcome.text")
  end

  def welcome_html_email(email_address) do
    email_address
    |> welcome_text_email()
    # <= Assignments
    |> render("welcome.html", email_address: email_address)
  end

  def restore_password_text_email(email_address) do
    new_email()
    |> to(email_address)
    |> from("support@sowproject.com")
    |> subject("Welcome!")
    |> render("restore_password.text")
  end

  def restore_password_html_email(email_address) do
    email_address
    |> restore_password_text_email()
    # <= Assignments
    |> render("restore_password.html", link: "http://localhost:4000/",email_address: email_address)
  end
end
