defmodule CobudgetAdminWeb.Plugs.Authentication do
  import Plug.Conn
  require Logger

  @client_id "297832829492-2pg47d6qvchgckduco9ck2i0ubem5sqj.apps.googleusercontent.com"
  @client_secret "5Yn2YMiYbUt9CLbj75fCJ3ev"
  @domain "greaterthan.finance"
  @login_duration 3600
  @auth_cookie "auth_cb"
  @forward_to_cookie "next_url"

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    case action(opts) do
      :require_auth -> require_auth(conn, opts)
      :login -> login(conn, opts)
      :callback -> callback(conn, opts)
    end
  end

  defp action(opts), do: Keyword.get(opts,:action)

  defp require_auth(conn, opts) do
    if is_authenticated?(conn) do
      conn
    else
      redirect_url = Keyword.get(opts,:redirect_url)
      Logger.debug "Redirecting to #{redirect_url}. Setting forward URL to #{conn.request_path}"
      conn
      |> put_resp_cookie(@forward_to_cookie, conn.request_path)
      |> redirect_to(redirect_url)
      |> halt()
    end    
  end

  defp login(conn, opts) do
    case GoogleApi.auth!(@client_id, oauth_redirect_uri(conn, opts), "profile email") do
      {body, headers, 302} ->
        conn = %{conn | resp_headers: headers}
        send_resp(conn, 302, body)
      {body, _headers, status} ->
        send_resp(conn, status, body)
    end
  end

  defp callback(conn, opts) do
    Logger.debug "Get an access token"
    token_response = GoogleApi.token!(@client_id, @client_secret, oauth_redirect_uri(conn, opts), conn.params["code"])
    info_response = GoogleApi.tokeninfo!(token_response["access_token"])
    case String.split(info_response["email"], "@") do
      [_name, @domain] -> 
        conn
        |> authenticate
        |> redirect_to(conn.cookies[@forward_to_cookie])
      _ -> 
        conn
        |> delete_authentication
        |> send_resp(401, "Authorization denied")
    end
  end

  defp oauth_redirect_uri(conn, opts) do
    callback = Keyword.get(opts,:callback)
    "http://#{conn.host}:#{conn.port}#{callback}"
  end

  defp is_authenticated?(conn) do
    fetch_cookies(conn).cookies[@auth_cookie] == "ok"
  end

  defp authenticate(conn) do
    put_resp_cookie(conn, @auth_cookie, "ok", max_age: @login_duration)
  end

  defp delete_authentication(conn) do
    delete_resp_cookie(conn, @auth_cookie)
  end

  defp redirect_to(conn, url) do
    conn
    |> put_resp_header("location",url)
    |> send_resp(302, "")
  end
end