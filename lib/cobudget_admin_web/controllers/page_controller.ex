defmodule CobudgetAdminWeb.PageController do
  use CobudgetAdminWeb, :controller

  alias CobudgetAdmin.LegacyDb

  def index(conn, _params) do
    render(conn, "index.html", groups: LegacyDb.group_analytics())
  end
end
