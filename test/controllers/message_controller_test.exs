defmodule SingleVoiceMessage.MessageControllerTest do
  use SingleVoiceMessage.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/", %{"AccountSid" => "AC123"}
    assert response(conn, 200) =~ "Hello from Phoenix"
  end

  test "PUT /?AccountSid=valid", %{conn: conn} do
    conn = put conn, "/", %{"AccountSid" => "AC123"}
    assert response(conn, 200) =~ "Message was updated"
  end

  test "PUT /?AccountSid=invalid", %{conn: conn} do
    conn = put conn, "/", %{"AccountSid" => "aaa"}
    assert response(conn, 401) =~ "Authentication failure"
  end
end
