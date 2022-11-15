defmodule River.Steps.ProcessForm.Test do
  use River.DataCase

  import River.Factory
  alias River.Steps.ProcessForm
  alias River.WorkflowEngine.Commands.NextEventCommand

  describe "run/2" do
    setup do
      workflow_session = insert(:workflow_session)

      step = %{
        "label" => "Process Form",
        "key" => "river/steps/process_form/1",
        "on" => "events/222",
        "config" => %{},
        "emits" => "events/333"
      }

      event = %{"key" => "events/222", "data" => %{"first_name" => "John", "last_name" => "Doe"}}

      {:ok, step: step, event: event, workflow_session: workflow_session}
    end

    test "returns a next event command", %{
      step: step,
      event: event,
      workflow_session: workflow_session
    } do
      assert ProcessForm.run(step, event, workflow_session) ==
               [
                 %NextEventCommand{
                   event: %{"key" => "events/333"}
                 }
               ]
    end

    test "saves data to workflow session", %{
      step: step,
      event: event,
      workflow_session: workflow_session
    } do
      ProcessForm.run(step, event, workflow_session)
      workflow_session = Repo.reload(workflow_session)

      assert workflow_session.data == %{
               "river/steps/process_form/1" => %{"first_name" => "John", "last_name" => "Doe"}
             }
    end
  end
end
