defmodule River.WorkflowEngine.Commands.NextEventCommand do
  @moduledoc """
  A command to move to the next event in the workflow.
  """
  @enforce_keys [:event]
  defstruct event: nil
  alias __MODULE__

  @type t() :: %__MODULE__{
          event: nil | map()
        }
  defimpl River.WorkflowEngine.Commands.Command do
    def execute(%NextEventCommand{event: event}, workflow_session) do
      River.WorkflowEngine.handle_event(workflow_session.workflow, event, workflow_session)
    end
  end
end
