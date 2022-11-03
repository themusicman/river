defmodule River.WorkflowEngine.Commands.UICommand do
  @moduledoc """
  A command to present a UI to the user.
  """
  @enforce_keys [:kind, :data]
  defstruct kind: "", data: %{}

  @type t() :: %__MODULE__{
          kind: String.t(),
          data: map()
        }

  defimpl River.WorkflowEngine.Commands.Command do
    def execute(command, workflow_session) do
      RiverWeb.Endpoint.broadcast!(
        "workflow:#{workflow_session.id}",
        "command",
        command
      )
    end
  end
end
