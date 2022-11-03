defmodule RiverWeb.Graphql.RespondWith.Mutation do
  @moduledoc """
  Graphql API response helpers
  """
  import AbsintheErrorPayload.Payload
  alias AbsintheErrorPayload.ValidationMessage
  alias RiverWeb.Graphql.RespondWith.Query

  def success(payload) do
    {:ok, success_payload(payload)}
  end

  def validation_errors(changeset) do
    {:ok, convert_to_payload(changeset)}
  end

  def error(code, field, message) do
    {:ok,
     error_payload(%ValidationMessage{
       code: code,
       field: field,
       message: message
     })}
  end

  def not_authorized(message \\ "Not authorized") do
    Query.not_authorized(message)
  end

  def not_found(message \\ "Not found") do
    Query.not_authorized(message)
  end
end
