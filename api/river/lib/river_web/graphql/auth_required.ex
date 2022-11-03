defmodule RiverWeb.Graphql.AuthRequired do
  @moduledoc """
  Absinthe middleware to require an authenticated query
  """
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{authenticated: true, user: true} ->
        resolution

      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Not Authorized"})
    end
  end
end
