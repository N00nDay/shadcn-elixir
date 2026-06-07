defmodule DemoWeb.RedirectController do
  @moduledoc "Small redirects for bare section URLs (e.g. /charts -> /charts/area)."
  use DemoWeb, :controller

  def charts(conn, _params), do: redirect(conn, to: "/charts/area")
  def blocks(conn, _params), do: redirect(conn, to: "/blocks/featured")
  def create(conn, _params), do: redirect(conn, to: "/create/preview-02")
end
