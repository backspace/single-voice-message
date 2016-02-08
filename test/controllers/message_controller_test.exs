defmodule SingleVoiceMessage.MessageControllerTest do
  use SingleVoiceMessage.ConnCase

  alias SingleVoiceMessage.Message

  test "GET / with no existing message", %{conn: conn} do
    conn = get conn, "/", %{"AccountSid" => "AC123"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Gather/@method") == "GET"
    assert Exml.get(doc, "//Gather/@action") == "/edit"

    assert Exml.get(doc, "//Say") =~ "Hello from Phoenix"
    assert Exml.get(doc, "//Gather/following-sibling::Redirect") == "/"
  end

  test "GET / with an existing message", %{conn: conn} do
    changeset = Message.changeset(%Message{}, %{"url" => "http://example.com/message.wav"})
    Repo.insert(changeset)

    conn = get conn, "/", %{"AccountSid" => "AC123"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Play") == "http://example.com/message.wav"
  end

  test "GET /edit without PIN", %{conn: conn} do
    conn = get conn, "/edit", %{"AccountSid" => "AC123", "Digits" => "abc"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Say") == "Authentication failure"
    assert Exml.get(doc, "//Redirect") == "/"
  end

  test "GET /edit with PIN", %{conn: conn} do
    conn = get conn, "/edit", %{"AccountSid" => "AC123", "Digits" => "12345"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Say") == "Please record the new message"

    assert Exml.get(doc, "//Record/@method") == "POST"
    assert Exml.get(doc, "//Record/@action") == "/"
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
