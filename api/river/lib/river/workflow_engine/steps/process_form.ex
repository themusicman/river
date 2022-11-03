defmodule River.WorkflowEngine.Steps.ProcessForm do
  @behaviour River.WorkflowEngine.Step
  alias River.WorkflowEngine.Steps
  alias River.WorkflowEngine.Commands.{UICommand, NextEventCommand}
  alias River.Workflows

  @impl River.WorkflowEngine.Step
  def handle(step, event, workflow_session) do
    session_data = Map.put(workflow_session.data, step["key"], event["data"])

    case Workflows.update_workflow_session(workflow_session, %{data: session_data}) do
      {:ok, _workflow_session} ->
        next_event = Steps.event_from_step(step)
        [%NextEventCommand{event: %{"key" => next_event}}]

      {:error, _changeset} ->
        [
          %UICommand{
            kind: "system/ui/toast",
            data: %{
              "message" => "Error saving form data",
              "type" => "error"
            }
          }
        ]
    end
  end
end
