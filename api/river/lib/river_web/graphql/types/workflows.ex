defmodule RiverWeb.Graphql.Types.Workflows do
  @moduledoc """
  User types for Graphql API
  """
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload
  alias RiverWeb.Graphql.Resolvers
  alias RiverWeb.Graphql.AppAuthRequired
  alias RiverWeb.Graphql.AuthRequired

  import_types(RiverWeb.Graphql.Scalars.Json)
  payload_object(:workflow_session_payload, :workflow_session)
  payload_object(:workflow_session_with_magic_link_payload, :workflow_session_with_magic_link)

  @desc "Represents the interactions a user has with a workflow"
  object :workflow_session do
    field(:id, non_null(:id))
    field(:external_identifier, non_null(:string))
    field(:token, non_null(:string))
    field(:email, non_null(:string))
  end

  @desc "Represents the workflow session and a magic link to access the workflow"
  object :workflow_session_with_magic_link do
    field(:magic_link, non_null(:string))
    field(:workflow_session, non_null(:workflow_session))
  end

  @desc "Trigger an event response"
  object :trigger_event_response do
    field(:workflow_session, non_null(:workflow_session))
  end

  input_object :event_input do
    field(:key, non_null(:string))
    field(:workflow_session_id, non_null(:id))
    field(:data, non_null(:json))
  end

  input_object :workflow_session_input do
    field(:workflow_key, non_null(:string))
    field(:external_identifier, non_null(:string))
    field(:email, non_null(:string))
  end

  object :workflow_mutations do
    @desc "Create a workflow session"
    field :create_workflow_session, :workflow_session_with_magic_link_payload do
      arg(:workflow_session, non_null(:workflow_session_input))
      middleware(AppAuthRequired)
      resolve(&Resolvers.Workflows.create_workflow_session/3)
    end

    @desc "Trigger an event"
    field :trigger_event, :workflow_session_payload do
      arg(:event, non_null(:event_input))
      middleware(AuthRequired)
      resolve(&Resolvers.Workflows.trigger_event/3)
    end
  end
end
