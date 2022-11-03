defmodule RiverWeb.Test.Graphql do
  @moduledoc """
  Helper functions for testing GraphQL
  """
  use Plug.Test
  alias RiverWeb.Router

  def execute(query, variables, auth \\ nil) do
    conn(:post, "/api/graphql", %{
      query: query,
      variables: variables
    })
    |> put_auth(auth)
    |> Router.call(router_opts())
  end

  def execute_and_decode(query, variables, auth \\ nil) do
    conn = execute(query, variables, auth)
    {conn, Jason.decode(conn.resp_body)}
  end

  def router_opts() do
    Router.init([])
  end

  def put_auth(conn, nil) do
    conn
  end

  def put_auth(conn, {token}) do
    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")
  end

  def put_auth(conn, {username, password}) do
    Plug.Conn.put_req_header(
      conn,
      "authorization",
      "Basic " <> Base.encode64("#{username}:#{password}")
    )
  end
end
