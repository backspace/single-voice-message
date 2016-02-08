defmodule SingleVoiceMessage.MessageControllerTest do
  use SingleVoiceMessage.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/", %{"AccountSid" => "AC123"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Say") == "Hello from Phoenix"
    assert Exml.get(doc, "//Say/following-sibling::Redirect") == "/"
  end

  test "PUT /?AccountSid=valid", %{conn: conn} do
    conn = put conn, "/", %{"AccountSid" => "AC123"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Say") == "Message was updated"
  end

  test "PUT /?AccountSid=invalid", %{conn: conn} do
    conn = put conn, "/", %{"AccountSid" => "aaa"}
    doc = Exml.parse(response(conn, 401))

    assert Exml.get(doc, "//Say") == "Authentication failure"
  end
end
