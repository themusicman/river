defmodule River.Steps.ShowPage.Test do
  use River.DataCase

  import River.Factory
  alias River.Steps.ShowPage
  alias River.WorkflowEngine.Commands.UICommand

  describe "run/2" do
    setup do
      workflow_session = insert(:workflow_session)

      step = %{
        "label" => "Show Page",
        "sequence" => "start",
        "position" => 1,
        "page" => %{"slug" => "page-1", "form" => %{"emits" => "events/333"}},
        "key" => "river/steps/show_page/1",
        "on" => "events/222",
        "config" => %{}
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
                 kind: "river/pages/show",
                 data: %{
                   "sequence" => "start",
                   "position" => 1,
                   "page" => %{"form" => %{"emits" => "events/333"}, "slug" => "page-1"}
                 }
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
                 kind: "river/pages/show",
                 data: %{
                   "sequence" => "start",
                   "position" => 1,
                   "page" => %{"form" => %{"emits" => "events/333"}, "slug" => "page-1"}
                 }
               }
             ]
    end
  end
end
