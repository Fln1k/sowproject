defmodule SowprojectWeb.MailController do
  def send_welcome_email do
    # Create your email
    Email.welcome_email()
    # Send your email
    |> Mailer.deliver_now()
  end
end
