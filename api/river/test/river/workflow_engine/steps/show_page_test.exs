defmodule River.WorkflowEngine.Steps.ShowPage.Test do
  use River.DataCase

  import River.Factory
  alias River.WorkflowEngine.Steps.ShowPage
  alias River.WorkflowEngine.Commands.UICommand

  describe "run/2" do
    setup do
      workflow_session = insert(:workflow_session)

      step = %{
        "label" => "Show Page",
        "key" => "system/steps/show_page/1",
        "on" => "events/222",
        "config" => %{"page" => %{"uri" => "/page-1", "form" => %{"emits" => "events/333"}}}
      }

      event = %{"key" => "events/222"}

      {:ok, step: step, event: event, workflow_session: workflow_session}
    end

    test "returns a ui command to show the page", %{
      step: step,
      event: event,
      workflow_session: workflow_session
    } do
      assert ShowPage.run(step, event, workflow_session) == [
               %UICommand{
                 kind: "system/pages/show",
                 data: %{"page" => %{"form" => %{"emits" => "events/333"}, "uri" => "/page-1"}}
               }
             ]
    end

    test "returns a ui command to show the form", %{
      step: step,
      event: event,
      workflow_session: workflow_session
    } do
      assert ShowPage.run(step, event, workflow_session) == [
               %UICommand{
                 kind: "system/pages/show",
                 data: %{"page" => %{"form" => %{"emits" => "events/333"}, "uri" => "/page-1"}}
               }
             ]
    end
  end
end
