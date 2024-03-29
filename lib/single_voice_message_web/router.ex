defmodule SingleVoiceMessageWeb.Router do
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

  scope "/", SingleVoiceMessageWeb do
    pipe_through :browser # Use the default browser stack

    get "/", MessageController, :show
    get "/edit", MessageController, :edit
    get "/preview", MessageController, :preview
    get "/approve", MessageController, :approve

    get "/log", MessageController, :log
  end

  # Other scopes may use custom stacks.
  # scope "/api", SingleVoiceMessage do
  #   pipe_through :api
  # end
end
