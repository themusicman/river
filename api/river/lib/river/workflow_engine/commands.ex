defprotocol River.WorkflowEngine.Commands.Command do
  @moduledoc """
  A command is a some work that needs to be done by the system.
  """
  @fallback_to_any true

  @doc """
  Executes a command.
  """
  def execute(command, workflow_session)
end
