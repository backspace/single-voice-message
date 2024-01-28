defmodule SingleVoiceMessage.MessageControllerTest do
  use SingleVoiceMessageWeb.ConnCase

  alias SingleVoiceMessage.Message

  test "GET /log", %{conn: conn} do
    conn = get conn, "/log", %{"AccountSid" => "AC123", "From" => "number"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Sms/@to") == "+12049832050"
    assert Exml.get(doc, "//Sms") == "Call from number"
    assert Exml.get(doc, "//Redirect") == "/"
  end

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

  # This SID check applies to all routes, not just GET /
  test "GET / without valid account SID", %{conn: conn} do
    conn = get conn, "/", %{"AccountSid" => "xxx"}
    doc = Exml.parse(response(conn, 401))

    assert Exml.get(doc, "//Say") == "Authentication failure"
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

    assert Exml.get(doc, "//Record/@method") == "GET"
    assert Exml.get(doc, "//Record/@action") == "/preview"
  end

  test "GET /preview", %{conn: conn} do
    conn = get conn, "/preview", %{"AccountSid" => "AC123", "RecordingUrl" => "http://example.com/new-message.wav"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Say") == "Here is the new message. Press one to accept, two to rerecord."

    assert Exml.get(doc, "//Play") == "http://example.com/new-message.wav"

    assert Exml.get(doc, "//Gather/@method") == "GET"
    assert Exml.get(doc, "//Gather/@action") == "/approve?RecordingUrl=http%3A%2F%2Fexample.com%2Fnew-message.wav"
    assert Exml.get(doc, "//Gather/@finishOnKey") == ""
    assert Exml.get(doc, "//Gather/@numDigits") == "1"
  end

  test "GET /approve?Digits=1 with no existing message", %{conn: conn} do
    conn = get conn, "/approve", %{"AccountSid" => "AC123", "Digits" => "1", "RecordingUrl" => "http://example.com/approved-message.wav"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Redirect") == "/"

    conn = get conn, "/", %{"AccountSid" => "AC123"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Play") == "http://example.com/approved-message.wav"
  end

  test "GET /approve?Digits=1 with an existing message", %{conn: conn} do
    changeset = Message.changeset(%Message{}, %{"url" => "http://example.com/existing-message.wav"})
    Repo.insert(changeset)

    conn = get conn, "/approve", %{"AccountSid" => "AC123", "Digits" => "1", "RecordingUrl" => "http://example.com/approved-message.wav"}
    doc = Exml.parse(response(conn, 200))
    assert Exml.get(doc, "//Redirect") == "/"

    conn = get conn, "/", %{"AccountSid" => "AC123"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Play") == "http://example.com/approved-message.wav"
  end

  test "GET /approve?Digits=2", %{conn: conn} do
    conn = get conn, "/approve", %{"AccountSid" => "AC123", "Digits" => "2", "RecordingUrl" => "irrelevant"}
    doc = Exml.parse(response(conn, 200))

    assert Exml.get(doc, "//Redirect") == "/edit?Digits=12345"
  end
end
