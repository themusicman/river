defmodule RiverWeb.Graphql.AppAuthRequired do
  @moduledoc """
  Absinthe middleware to require an authenticated query at the application level
  """
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{authenticated: true, application: true} ->
        resolution

      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Not Authorized"})
    end
  end
end
