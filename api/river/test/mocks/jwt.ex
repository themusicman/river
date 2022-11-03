defmodule River.Mocks.JWT do
  @moduledoc """
  Test helpers for JWT mocks
  """
  import Mox

  @doc """
  Returns the claims
  """
  def expect_jwt_get_claims(claims) do
    RiverWeb.JWT.TokenMock |> expect(:get_claims, fn _token -> {:ok, claims} end)
  end
end
