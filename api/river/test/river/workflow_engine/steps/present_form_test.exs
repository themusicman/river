defmodule River.WorkflowEngine.Steps.PresentForm.Test do
  use River.DataCase

  import River.Factory
  alias River.WorkflowEngine.Steps.PresentForm
  alias River.WorkflowEngine.Commands.UICommand

  describe "handle/2" do
    setup do
      workflow_session = insert(:workflow_session)

      step = %{
        "label" => "Present Form",
        "key" => "system/steps/present_form/1",
        "on" => "events/222",
        "config" => %{"form" => %{"emits" => "events/333"}, "uri" => "/form"}
      }

      event = %{"key" => "events/222"}

      {:ok, step: step, event: event, workflow_session: workflow_session}
    end

    test "returns a ui command to present the form", %{
      step: step,
      event: event,
      workflow_session: workflow_session
    } do
      assert PresentForm.handle(step, event, workflow_session) == [
               %UICommand{
                 kind: "system/forms/present",
                 data: %{"form" => %{"emits" => "events/333"}, "uri" => "/form"}
               }
             ]
    end
  end
end
