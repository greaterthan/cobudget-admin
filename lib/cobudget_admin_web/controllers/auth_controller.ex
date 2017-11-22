defmodule CobudgetAdminWeb.AuthController do
  use CobudgetAdminWeb, :controller
  require Logger

  @client_id "297832829492-2pg47d6qvchgckduco9ck2i0ubem5sqj.apps.googleusercontent.com"
  @client_secret "5Yn2YMiYbUt9CLbj75fCJ3ev"
  @domain "greaterthan.finance"

  def login(conn, _params) do
    Logger.debug "Attempting login"
    case GoogleApi.auth!(@client_id, "http://localhost:4000/googleauth", "profile email") do
      {body, headers, 302} ->
        conn = %{conn | resp_headers: headers}
        send_resp(conn, 302, body)
      {body, _headers, status} ->
        send_resp(conn, status, body)
    end
  end

  def googleauth(conn, params) do
    Logger.debug "Get an access token"
    token_response = GoogleApi.token!(@client_id, @client_secret, "http://localhost:4000/googleauth", params["code"])
    info_response = GoogleApi.tokeninfo!(token_response["access_token"])
    case String.split(info_response["email"], "@") do
      [_name, @domain] -> send_resp(conn, 200, "Access authorized")
      _ -> send_resp(conn, 401, "Authorization denied")
    end
  end

end
