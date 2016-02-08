defmodule SingleVoiceMessage.MessageControllerTest do
  use SingleVoiceMessage.ConnCase

  test "PUT /message?AccountSid=valid", %{conn: conn} do
    conn = put conn, "/message", %{"AccountSid" => "AC123"}
    assert response(conn, 200) =~ "Message was updated"
  end

  test "PUT /message?AccountSid=invalid", %{conn: conn} do
    conn = put conn, "/message", %{"AccountSid" => "aaa"}
    assert response(conn, 200) =~ "Message was not updated"
  end
end
