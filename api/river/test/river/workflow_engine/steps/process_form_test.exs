defmodule River.WorkflowEngine.Steps.ProcessForm.Test do
  use River.DataCase

  import River.Factory

  describe "run/2" do
    setup do
      workflow_session = insert(:workflow_session)

      step = %{
        "label" => "Process Form",
        "key" => "system/steps/process_form/1",
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
      assert River.WorkflowEngine.Steps.ProcessForm.run(step, event, workflow_session) ==
               [
                 %River.WorkflowEngine.Commands.NextEventCommand{
                   event: %{"key" => "events/333"}
                 }
               ]
    end

    test "saves data to workflow session", %{
      step: step,
      event: event,
      workflow_session: workflow_session
    } do
      River.WorkflowEngine.Steps.ProcessForm.run(step, event, workflow_session)
      workflow_session = Repo.reload(workflow_session)

      assert workflow_session.data == %{
               "system/steps/process_form/1" => %{"first_name" => "John", "last_name" => "Doe"}
             }
    end
  end
end
