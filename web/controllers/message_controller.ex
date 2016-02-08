defmodule SingleVoiceMessage.MessageController do
  use SingleVoiceMessage.Web, :controller

  alias SingleVoiceMessage.Message

  plug :authenticate

  def show(conn, _params) do
    messages = Repo.all(Message)

    # FIXME there must be a more idiomatic way
    message = case length(messages) do
      0 -> nil
      _ -> hd(messages)
    end

    render conn, "show.xml", message: message
  end

  def edit(conn, %{"Digits" => pin}) do
    permit_editing = case Application.get_env(:single_voice_message, :pin) do
      ^pin -> true
      _ -> false
    end

    render conn, "edit.xml", permit_editing: permit_editing
  end

  def preview(conn, %{"RecordingUrl" => recording_url}) do
    render conn, "preview.xml", recording_url: recording_url
  end

  def approve(conn, _) do
    render conn, "approve.xml"
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
