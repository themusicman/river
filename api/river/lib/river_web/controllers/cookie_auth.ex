defmodule RiverWeb.Controllers.CookieAuth do
  @moduledoc """
  Contains helper functions related to cookie authentication
  """
  import Plug.Conn

  @max_age 60 * 60 * 24 * 60
  @jwt_cookie "_river_web_jwt"

  def write_jwt_cookie(conn, workflow_session) do
    jwt = RiverWeb.JWT.Token.token(%{external_identifier: workflow_session.external_identifier})
    use_secure = if River.environment() == :prod, do: true, else: false

    put_resp_cookie(conn, @jwt_cookie, jwt,
      sign: false,
      max_age: @max_age,
      same_site: "None",
      secure: use_secure,
      http_only: true
    )
  end
end
