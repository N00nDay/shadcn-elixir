defmodule DemoWeb.Router do
  use DemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DemoWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/docs", DocsLive
    live "/docs/components/:component", ComponentLive
    live "/docs/:page", DocsLive
    get "/charts", RedirectController, :charts
    live "/charts/:category", ChartsLive
    get "/blocks", RedirectController, :blocks
    live "/blocks/:category", BlocksLive
    get "/create", RedirectController, :create
    get "/create/frame", CreateFrameController, :show
    live "/create/:item", CreateLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", DemoWeb do
  #   pipe_through :api
  # end
end
