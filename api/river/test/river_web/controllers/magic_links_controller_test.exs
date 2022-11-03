defmodule RiverWeb.MagicLinksControllerTest do
  use RiverWeb.ConnCase
  alias River.Workflows
  import River.Factory
  # alias RiverWeb.Router.Helpers, as: Routes

  describe "GET /v/:token" do
    test "redirects to SPA workflow when given valid token", %{conn: conn} do
      workflow_session = insert(:workflow_session)
      {token, _} = Workflows.generate_workflow_session_token!(workflow_session)
      conn = get(conn, Routes.magic_links_path(conn, :verify, token))
      assert redirected_to(conn) == "http://localhost:3000/#{workflow_session.workflow.uri}"

      assert %Plug.Conn{
               resp_cookies: %{
                 "_river_web_jwt" => %{
                   http_only: true,
                   max_age: 5_184_000,
                   same_site: "None",
                   secure: false,
                   value: jwt
                 }
               }
             } = conn

      external_identifier = workflow_session.external_identifier

      assert {:ok, %{"external_identifier" => ^external_identifier}} =
               RiverWeb.JWT.Token.get_claims(jwt)
    end

    test "displays error message if given invalid token", %{conn: conn} do
      conn = get(conn, Routes.magic_links_path(conn, :verify, "invalid-token"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) == "Token expired"
    end
  end
end
