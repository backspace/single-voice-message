defmodule SingleVoiceMessage.PageController do
  use SingleVoiceMessage.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
