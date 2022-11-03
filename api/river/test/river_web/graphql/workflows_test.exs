defmodule RiverWeb.Graphql.Workflows.Test do
  @moduledoc """
  Tests related to workflows
  """
  import River.Factory
  use River.DataCase, async: true
  alias RiverWeb.Test.Graphql
  alias River.WorkflowsFixtures

  setup do
    token = RiverWeb.JWT.Token.token()
    document = WorkflowsFixtures.document()
    workflow = insert(:workflow, document: document)
    %{token: token, workflow: workflow}
  end

  describe "createWorkflowSession" do
    @query """
    mutation CreateWorkflowSession($workflowSession: WorkflowSessionInput!) {
      createWorkflowSession(workflowSession: $workflowSession) {
        result {
          magicLink
          workflowSession {
            id
            token
            email
            externalIdentifier
          }
        }
        successful
        messages {
          field
          message
        }
      }
    }
    """

    test "returns workflowSession", %{workflow: workflow} do
      expected_external_identifier = "test-external-identifier"

      case Graphql.execute_and_decode(
             @query,
             %{
               workflowSession: %{
                 workflowKey: workflow.key,
                 externalIdentifier: expected_external_identifier,
                 email: Faker.Internet.email()
               }
             },
             {"testkey", "testsecret"}
           ) do
        {_conn, {:ok, response}} ->
          assert %{
                   "data" => %{
                     "createWorkflowSession" => %{
                       "messages" => _messages,
                       "successful" => true,
                       "result" => %{
                         "workflowSession" => %{
                           "externalIdentifier" => ^expected_external_identifier,
                           "id" => id
                         },
                         "magicLink" => magic_link
                       }
                     }
                   }
                 } = response

          refute id == nil
          refute magic_link == nil

        _ ->
          flunk("Could not parse response")
      end
    end
  end

  describe "triggerEvent" do
    @query """
    mutation TriggerEvent($event: EventInput!) {
      triggerEvent(event: $event) {
        result {
          id
          externalIdentifier
        }
        successful
        messages {
          field
          message
        }
      }
    }
    """

    test "returns workflowSession", %{workflow: workflow, token: token} do
      workflow_session = insert(:workflow_session, workflow: workflow)

      data =
        case Jason.encode(%{
               "first_name" => "Thomas"
             }) do
          {:ok, data} -> data
          _ -> flunk("Could not encode data")
        end

      case Graphql.execute_and_decode(
             @query,
             %{
               event: %{
                 key: "events/123",
                 workflowSessionId: workflow_session.id,
                 data: data
               }
             },
             {token}
           ) do
        {_conn, {:ok, response}} ->
          assert %{
                   "data" => %{
                     "triggerEvent" => %{
                       "messages" => _messages,
                       "successful" => true,
                       "result" => %{
                         "id" => id,
                         "externalIdentifier" => external_identifier
                       }
                     }
                   }
                 } = response

          assert River.to_integer(id) == workflow_session.id
          assert external_identifier == workflow_session.external_identifier

        _ ->
          flunk("Could not parse response")
      end
    end
  end
end
