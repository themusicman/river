defmodule RiverWeb.Graphql.Context do
  @moduledoc """
  Provides the context for the Graphql API
  """

  @behaviour Plug

  require Logger
  import Plug.Conn
  alias RiverWeb.JWT.Auth

  def init(opts) do
    opts
  end

  def call(conn, opts \\ %{}) do
    opts = Keyword.put(opts, :except, Keyword.get(opts, :except, []))
    {conn, context} = build_context(conn, opts)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the context based on the authorization header
  """
  def build_context(conn, _opts) do
    context = %{authenticated: false, application: false, user: false}
    bearer_token_from_cookie = conn |> fetch_cookies() |> get_bearer_token_from_cookie()
    authorization_header = get_req_header(conn, "authorization")

    context =
      case authorization_header do
        ["Basic " <> encoded_key_and_secret] ->
          with {:ok, decoded_key_and_secret} <- Base.decode64(encoded_key_and_secret),
               [key, secret] <- :binary.split(decoded_key_and_secret, ":") do
            if check_basic_auth(key, secret) do
              %{context | authenticated: true, application: true}
            else
              context
            end
          else
            _ -> context
          end

        ["Bearer " <> bearer_token] ->
          Auth.get_claims_from_bearer_token(bearer_token) |> put_claims_in_context(context)

        _ ->
          if bearer_token_from_cookie do
            Auth.get_claims_from_bearer_token(bearer_token_from_cookie)
            |> put_claims_in_context(context)
          else
            context
          end
      end

    {conn, context}
  end

  def check_basic_auth(key, secret) do
    case Application.get_env(:river, :basic_auth) do
      nil ->
        false

      {basic_auth_key, basic_auth_secret} ->
        key == basic_auth_key && secret == basic_auth_secret
    end
  end

  def get_bearer_token_from_cookie(%Plug.Conn{cookies: %{"_river_web_jwt" => bearer_token}}) do
    bearer_token
  end

  def get_bearer_token_from_cookie(_) do
    false
  end

  def put_claims_in_context({:ok, claims}, context) do
    context
    |> Map.merge(claims)
    |> Map.merge(%{
      authenticated: true,
      user: true
    })
  end

  def put_claims_in_context({:error, reason}, _context) do
    Logger.error(reason)
    %{authenticated: false}
  end

  def halt_with_not_authorized(conn) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(:unauthorized, "Not Authorized")
    |> halt
  end
end
