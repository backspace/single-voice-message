defmodule SingleVoiceMessage.MessageController do
  use SingleVoiceMessage.Web, :controller

  plug :authenticate

  def show(conn, _params) do
    render conn, "show.xml"
  end

  def update(conn, _) do
    render conn, "update.xml"
  end

  defp authenticate(%Plug.Conn{params: %{"AccountSid" => request_twilio_account_sid}} = conn, _) do
    case Application.get_env(:single_voice_message, :twilio_account_sid) do
      ^request_twilio_account_sid ->
        conn
      _ ->
        conn
        |> put_status(401)
        |> render("401.xml")
        |> halt
    end
  end
end
