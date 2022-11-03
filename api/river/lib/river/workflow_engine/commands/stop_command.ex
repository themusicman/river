defmodule River.WorkflowEngine.Commands.StopCommand do
  @moduledoc """
  A command to stop the workflow.
  """
  defstruct event: ""

  @type t() :: %__MODULE__{
          event: map()
        }

  defimpl River.WorkflowEngine.Commands.Command do
    def execute(_command, _workflow_session) do
      # Do nothing
    end
  end
end
