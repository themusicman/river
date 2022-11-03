defmodule RiverWeb.WorkflowChannelTest do
  use RiverWeb.ChannelCase
  import River.Factory
  import Mox
  alias River.WorkflowsFixtures

  setup :verify_on_exit!

  describe "valid authentication" do
    setup do
      document = WorkflowsFixtures.document()
      workflow = insert(:workflow, document: document)
      workflow_session = insert(:workflow_session, workflow: workflow)

      River.Mocks.JWT.expect_jwt_get_claims(%{
        external_identifier: workflow_session.external_identifier
      })

      {:ok, _, socket} =
        RiverWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(RiverWeb.WorkflowChannel, "workflow:#{workflow_session.id}", %{
          "token" => workflow_session.token
        })

      %{socket: socket}
    end

    test "triggers an event", %{socket: socket} do
      event = %{"key" => "events/123", "data" => %{"foo" => "bar"}}
      ref = push(socket, "trigger_event", event)
      assert_reply ref, :ok, %{"success" => true}

      assert_broadcast "command",
                       %River.WorkflowEngine.Commands.UICommand{
                         data: %{
                           "uri" => "/form",
                           "form" => %{"emits" => "events/456", "schema" => %{}}
                         },
                         kind: "system/forms/present"
                       }
    end
  end

  describe "invalid authentication" do
    test "does not allow connection" do
      workflow_session = insert(:workflow_session)

      {:error, %{reason: reason}} =
        RiverWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(RiverWeb.WorkflowChannel, "workflow:#{workflow_session.id}")

      assert reason == "unauthorized"
    end
  end
end
