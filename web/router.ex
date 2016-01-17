defmodule Qwestr.Router do
  use Qwestr.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Qwestr.Auth, repo: Qwestr.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Qwestr do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/manage", Qwestr do
    pipe_through [:browser, :authenticate_user]

    resources "/qwests", QwestController
    get "/qwests/:id/complete", QwestController, :complete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Qwestr do
  #   pipe_through :api
  # end
end
