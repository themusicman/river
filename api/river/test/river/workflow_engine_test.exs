defmodule River.WorkflowEngine.Test do
  use River.DataCase

  import River.Factory

  describe "handle_event/2" do
    setup do
      document = %{
        "key" => "workflow/1",
        "steps" => [
          %{
            "label" => "Present Form",
            "key" => "system/steps/present_form/1",
            "on" => "events/123",
            "config" => %{
              "uri" => "/form",
              "form" => %{
                "emits" => "events/456",
                "schema" => %{}
              }
            }
          },
          %{
            "label" => "Stop",
            "key" => "system/steps/stop/2",
            "on" => "events/123",
            "config" => %{}
          },
          %{
            "label" => "Process Form",
            "key" => "system/steps/process_form/3",
            "on" => "events/456",
            "config" => %{},
            "emits" => "events/789"
          }
        ]
      }

      workflow = insert(:workflow, document: document)
      workflow_session = insert(:workflow_session, workflow: workflow)

      {:ok, workflow: workflow, workflow_session: workflow_session}
    end

    test "returns a list of stop and ui commands", %{
      workflow: workflow,
      workflow_session: workflow_session
    } do
      event = %{"key" => "events/123"}

      assert River.WorkflowEngine.handle_event(workflow, event, workflow_session) == [
               %River.WorkflowEngine.Commands.UICommand{
                 data: %{"uri" => "/form", "form" => %{"emits" => "events/456", "schema" => %{}}},
                 kind: "system/forms/present"
               },
               %River.WorkflowEngine.Commands.StopCommand{event: %{"key" => "events/123"}}
             ]
    end
  end
end
