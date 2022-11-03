defmodule RiverWeb.JWT.TokenAdapter do
  @moduledoc """
  Adapter for the JWT Token
  """
  @callback token(map()) :: binary()
  @callback workflow_session_token(WorkflowSession.t()) :: binary()
  @callback get_claims(binary()) :: {:ok, map()} | {:error, any()}
end

defmodule RiverWeb.JWT.Token do
  @moduledoc """
  JWT tokens 
  """
  use Joken.Config
  @behaviour RiverWeb.JWT.TokenAdapter

  @impl RiverWeb.JWT.TokenAdapter
  def workflow_session_token(workflow_session) do
    token(%{external_identifier: workflow_session.external_identifier})
  end

  @impl RiverWeb.JWT.TokenAdapter
  def token(claims \\ %{}) do
    claims = Map.merge(claims, %{exp: token_exp()})

    {:ok, token, _claims} =
      encode_and_sign(
        claims,
        signer()
      )

    token
  end

  defp token_exp() do
    DateTime.now!("Etc/UTC") |> DateTime.add(2_592_000) |> DateTime.to_unix()
  end

  @spec signer :: Joken.Signer.t()
  def signer do
    key = Application.get_env(:river, :jwt_secret)
    Joken.Signer.create("HS256", key)
  end

  @impl RiverWeb.JWT.TokenAdapter
  @spec get_claims(binary) :: {:error, atom | keyword} | {:ok, %{optional(binary) => any}}
  def get_claims(token) do
    verify_and_validate(
      token,
      signer()
    )
  end
end
