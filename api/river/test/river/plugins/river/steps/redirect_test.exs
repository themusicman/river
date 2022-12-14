defmodule River.Steps.Redirect.Test do
  use River.DataCase

  import River.Factory
  alias River.Steps.Redirect
  alias River.WorkflowEngine.Commands.UICommand

  describe "run/2" do
    setup do
      workflow_session = insert(:workflow_session)

      step = %{
        "label" => "Redirect",
        "key" => "river/steps/redirect/1",
        "on" => "events/222",
        "config" => %{"url" => "https://www.google.com"}
      }

      event = %{"key" => "events/222"}

      {:ok, step: step, event: event, workflow_session: workflow_session}
    end

    test "returns a ui command to show the form", %{
      step: step,
      event: event,
      workflow_session: workflow_session
    } do
      assert Redirect.run(step, event, workflow_session) == [
               %UICommand{
                 kind: "river/ui/redirect",
                 data: %{"url" => "https://www.google.com"}
               }
             ]
    end
  end
end
