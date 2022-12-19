defmodule TwtrWeb.PageController do
  use TwtrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
