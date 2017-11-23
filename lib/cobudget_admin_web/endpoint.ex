defmodule CobudgetAdminWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :cobudget_admin
  require Logger

  socket "/socket", CobudgetAdminWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :cobudget_admin, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug :test
  plug Plug.Session,
    store: :cookie,
    key: "_cobudget_admin_key",
    signing_salt: "+r2PtGxe"

  plug CobudgetAdminWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end

  def test(conn, _opts) do
    Logger.info "test_auth cookie=#{inspect fetch_cookies(conn).cookies["test_auth"]}"
    Logger.info "request_path=#{conn.request_path}"
    Logger.info "path_info=#{inspect conn.path_info}"
    if Enum.count(conn.path_info) > 0 && Enum.at(conn.path_info,0) == "auth" do
      conn
    else
      case fetch_cookies(conn).cookies["test_auth"] do
        "ok" ->
          conn
        _ ->
          conn
          |> put_resp_cookie("next_url",conn.request_path)
          |> put_resp_header("location","http://localhost:4000/auth/login")
          |> send_resp(302, "")
          |> halt()
      end
    end
  end

end
