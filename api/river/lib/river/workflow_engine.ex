defmodule River.WorkflowEngine do
  @moduledoc """
  The WorkflowEngine is responsible for executing the workflow logic.
  """
  alias River.WorkflowEngine.Steps
  require Logger

  def handle_event(workflow, event, workflow_session) do
    Steps.get_all_for_event(workflow, event)
    |> Enum.map(&Steps.run(&1, event, workflow_session))
    |> List.flatten()
  end
end
