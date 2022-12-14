defmodule River.Steps.Stop do
  @behaviour River.WorkflowEngine.Step
  alias River.WorkflowEngine.Commands.StopCommand

  @impl River.WorkflowEngine.Step
  def run(_step, event, _workflow_session) do
    [%StopCommand{event: event}]
  end
end
