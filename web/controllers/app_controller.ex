defmodule Parcelmagic.AppController do
  use Parcelmagic.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
