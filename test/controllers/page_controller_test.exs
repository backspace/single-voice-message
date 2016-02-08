defmodule SingleVoiceMessage.PageControllerTest do
  use SingleVoiceMessage.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert response(conn, 200) =~ "Hello from Phoenix"
  end
end
