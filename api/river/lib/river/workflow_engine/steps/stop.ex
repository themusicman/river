defmodule River.WorkflowEngine.Steps.Stop do
  @behaviour River.WorkflowEngine.Step
  alias River.WorkflowEngine.Commands.StopCommand

  @impl River.WorkflowEngine.Step
  def handle(_step, event, _workflow_session) do
    [%StopCommand{event: event}]
  end
end
