defmodule GoogleApi do

  def auth!(client_id, redirect_uri, scope) do
    response = HTTPoison.get! "https://accounts.google.com/o/oauth2/v2/auth", [],
      [params: [{"client_id",@client_id},
                {"redirect_uri","http://localhost:5000/googleauth"},
                {"scope","profile email"},
                {"response_type","code"}]]            
    {response.body, response.headers, response.status_code}
  end

  def token!(client_id, client_secret, redirect_uri, code) do
    response = HTTPoison.post! "https://www.googleapis.com/oauth2/v4/token", 
      {:form, [{"code",code},
               {"client_id", client_id},
               {"client_secret", client_secret},
               {"redirect_uri",redirect_uri},
               {"grant_type","authorization_code"}]}
    Poison.decode! response.body
  end

  def tokeninfo!(access_token) do
    response = HTTPoison.get! "https://www.googleapis.com/oauth2/v3/tokeninfo", [],
      [params: [{"access_token",access_token}]]
    Poison.decode! response.body
  end
end