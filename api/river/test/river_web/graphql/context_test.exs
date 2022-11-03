defmodule RiverWeb.Graphql.Context.Test do
  use River.DataCase, async: true
  use Plug.Test
  import River.Factory
  alias RiverWeb.Graphql.Context

  def router_opts() do
    Context.init([])
  end

  describe "bearer token" do
    test "set authenticated to false if the bearer token does not exist" do
      conn =
        :post
        |> conn("/api/graphql", "")
        |> Context.call(router_opts())

      assert %Plug.Conn{
               private: %{absinthe: %{context: %{authenticated: false, user: false}}}
             } = conn
    end

    test "set authenticated to true if bearer token is valid token" do
      token = RiverWeb.JWT.Token.token(%{})

      conn =
        :post
        |> conn("/api/graphql", "")
        |> put_req_header("authorization", "Bearer #{token}")
        |> Context.call(router_opts())

      assert %Plug.Conn{
               private: %{absinthe: %{context: %{authenticated: true, user: true}}}
             } = conn
    end
  end

  describe "basic auth" do
    test "set authenticated to false if credentials are invalid" do
      conn =
        :post
        |> conn("/api/graphql", "")
        |> put_req_header("authorization", "Basic #{Base.encode64("invalid:credentials")}")
        |> Context.call(router_opts())

      assert %Plug.Conn{
               private: %{
                 absinthe: %{context: %{authenticated: false, application: false}}
               }
             } = conn
    end

    test "set authenticated to true if credentials are valid" do
      conn =
        :post
        |> conn("/api/graphql", "")
        |> put_req_header(
          "authorization",
          "Basic #{Base.encode64("testkey:testsecret")}"
        )
        |> Context.call(router_opts())

      assert %Plug.Conn{
               private: %{absinthe: %{context: %{authenticated: true, application: true}}}
             } = conn
    end
  end

  describe "cookie based auth" do
    setup do
      workflow_session = insert(:workflow_session)
      token = RiverWeb.JWT.Token.workflow_session_token(workflow_session)
      {:ok, token: token}
    end

    test "set authenticated to true if cookie has valid JWT", %{token: token} do
      conn =
        :post
        |> conn("/api/graphql", "")
        |> put_req_cookie("_river_web_jwt", token)
        |> Context.call(router_opts())

      assert %Plug.Conn{
               private: %{absinthe: %{context: %{authenticated: true, user: true}}}
             } = conn
    end
  end
end
