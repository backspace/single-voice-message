defmodule SingleVoiceMessage.Router do
  use SingleVoiceMessage.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SingleVoiceMessage do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/message", MessageController, singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", SingleVoiceMessage do
  #   pipe_through :api
  # end
end
