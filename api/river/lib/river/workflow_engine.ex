defmodule River.WorkflowEngine do
  @moduledoc """
  The WorkflowEngine is responsible for executing the workflow logic.
  """
  alias River.WorkflowEngine.Steps
  alias River.WorkflowEngine.Commands.Command
  require Logger

  def handle_event(workflow, event, workflow_session) do
    Steps.get_all_for_event(workflow, event)
    |> Enum.map(&Steps.run(&1, event, workflow_session))
    |> List.flatten()
  end

  def handle_commands(commands, workflow_session) do
    Enum.map(commands, &Command.execute(&1, workflow_session))
  end
end
