defmodule River.WorkflowEngine.Test do
  use River.DataCase

  import River.Factory
  alias River.WorkflowEngine
  alias River.WorkflowEngine.Commands.{UICommand, StopCommand}

  describe "handle_event/2" do
    setup do
      document = %{
        "key" => "workflow/1",
        "steps" => [
          %{
            "label" => "Present Form",
            "key" => "river/steps/show_page/1",
            "on" => "events/123",
            "sequence" => "onboarding",
            "position" => 1,
            "page" => %{
              "slug" => "form",
              "form" => %{
                "emits" => "events/456",
                "schema" => %{}
              }
            },
            "config" => %{}
          },
          %{
            "label" => "Stop",
            "key" => "river/steps/stop/2",
            "on" => "events/123",
            "config" => %{}
          },
          %{
            "label" => "Process Form",
            "key" => "river/steps/process_form/3",
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

      assert WorkflowEngine.handle_event(workflow, event, workflow_session) == [
               %UICommand{
                 data: %{
                   "sequence" => "onboarding",
                   "position" => 1,
                   "page" => %{
                     "slug" => "form",
                     "form" => %{"emits" => "events/456", "schema" => %{}}
                   }
                 },
                 kind: "river/pages/show"
               },
               %StopCommand{event: %{"key" => "events/123"}}
             ]
    end
  end
end
