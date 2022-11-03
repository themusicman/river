defmodule RiverWeb.JWT.Auth do
  @moduledoc """
  JWT Authorization
  """
  require Logger
  alias RiverWeb.JWT.Token

  @spec get_claims_from_bearer_token(binary()) :: {:ok, map()} | {:error, any()}
  def get_claims_from_bearer_token(bearer_token) do
    Token.get_claims(bearer_token)
  end
end
