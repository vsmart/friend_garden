defmodule FriendGarden.Router do
  use FriendGarden.Web, :router
  use Addict.RoutesHelper

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :fetch_conn do
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :fetch_conn
    addict :routes
  end

  scope "/", FriendGarden do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index, as: :root
    resources "/friends", FriendController
  end
end
