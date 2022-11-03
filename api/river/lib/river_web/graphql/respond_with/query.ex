defmodule RiverWeb.Graphql.RespondWith.Query do
  @moduledoc """
  Graphql API response helpers
  """
  alias RiverWeb.Graphql.PaginatedResults

  def success(%PaginatedResults{} = paginated) do
    {:ok, %{results: paginated.results, pagination: paginated}}
  end

  def success(payload) do
    {:ok, payload}
  end

  def not_authorized(message \\ "Not authorized") do
    error(message)
  end

  def not_found(message \\ "Not found") do
    error(message)
  end

  def error(message) do
    {:error, message}
  end
end
