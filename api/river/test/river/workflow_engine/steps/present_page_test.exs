defmodule River.WorkflowEngine.Steps.PresentPage.Test do
  use River.DataCase

  import River.Factory
  alias River.WorkflowEngine.Steps.PresentPage
  alias River.WorkflowEngine.Commands.UICommand

  describe "run/2" do
    setup do
      workflow_session = insert(:workflow_session)

      step = %{
        "label" => "Present Page",
        "key" => "system/steps/present_page/1",
        "on" => "events/222",
        "config" => %{"uri" => "/page-1"}
      }

      event = %{"key" => "events/222"}

      {:ok, step: step, event: event, workflow_session: workflow_session}
    end

    test "returns a ui command to present the page", %{
      step: step,
      event: event,
      workflow_session: workflow_session
    } do
      assert PresentPage.run(step, event, workflow_session) == [
               %UICommand{
                 kind: "system/pages/present",
                 data: %{"uri" => "/page-1"}
               }
             ]
    end
  end
end
