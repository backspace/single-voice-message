defmodule SingleVoiceMessage.MessageController do
  use SingleVoiceMessage.Web, :controller

  def update(conn, %{"AccountSid" => request_twilio_account_sid}) do
    case Application.get_env(:single_voice_message, :twilio_account_sid) do
      ^request_twilio_account_sid ->
        render conn, "update.xml", changed: true
      _ ->
        render conn, "update.xml", changed: false
    end
  end
end
