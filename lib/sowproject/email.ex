defmodule Sowproject.Email do
  use Bamboo.Phoenix, view: SowprojectWeb.EmailView

  def welcome_html_email(email_address) do
    new_email()
    |> to(email_address)
    |> from("support@sowproject.com")
    |> subject("Welcome Mail")
    |> render("welcome.html", email_address: email_address)
  end

  def restore_password_html_email(email_address, token) do
    new_email()
    |> to(email_address)
    |> from(Application.get_env(:sowproject, Sowproject.Mailer)[:from])
    |> subject("Password Restore")
    |> render("restore_password.html",
      link: "#{SowprojectWeb.Endpoint.url()}/restorepassword?token=#{token}",
      email_address: email_address
    )
  end
end
