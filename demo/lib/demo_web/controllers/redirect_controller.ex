defmodule DemoWeb.RedirectController do
  @moduledoc "Small redirects for bare section URLs (e.g. /charts -> /charts/area)."
  use DemoWeb, :controller

  def charts(conn, _params), do: redirect(conn, to: "/charts/area")
end
