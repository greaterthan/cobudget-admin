defmodule CobudgetAdminWeb.AuthController do
  use CobudgetAdminWeb, :controller
  require Logger

  @client_id "297832829492-2pg47d6qvchgckduco9ck2i0ubem5sqj.apps.googleusercontent.com"
  @client_secret "5Yn2YMiYbUt9CLbj75fCJ3ev"
  @domain "greaterthan.finance"
  @login_duration 3600

  def login(conn, _params) do
    Logger.debug "Attempting login"
    Logger.info "host=#{conn.host}"
    Logger.info "port=#{conn.port}"
    redirect_uri = "http://#{conn.host}:#{conn.port}/auth/googleauth"
    case GoogleApi.auth!(@client_id, redirect_uri, "profile email") do
      {body, headers, 302} ->
        conn = %{conn | resp_headers: headers}
        send_resp(conn, 302, body)
      {body, _headers, status} ->
        send_resp(conn, status, body)
    end
  end

  def googleauth(conn, params) do
    Logger.debug "Get an access token"
    redirect_uri = "http://#{conn.host}:#{conn.port}/auth/googleauth"
    token_response = GoogleApi.token!(@client_id, @client_secret, redirect_uri, params["code"])
    info_response = GoogleApi.tokeninfo!(token_response["access_token"])
    case String.split(info_response["email"], "@") do
      [_name, @domain] -> 
        conn
        |> put_resp_cookie("auth_cb","ok", max_age: @login_duration)
        |> put_resp_header("location",conn.cookies["next_url"])
        |> delete_resp_cookie("next_url")
        |> send_resp(302, "")
      _ -> 
        conn
        |> delete_resp_cookie("test_auth")
        |> send_resp(401, "Authorization denied")
    end
  end

end
