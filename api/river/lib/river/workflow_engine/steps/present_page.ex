defmodule River.WorkflowEngine.Steps.PresentPage do
  @behaviour River.WorkflowEngine.Step
  alias River.WorkflowEngine.Commands.UICommand

  @impl River.WorkflowEngine.Step
  def run(%{"config" => %{"uri" => uri}}, _event, _workflow_session) do
    command = %UICommand{
      kind: "system/pages/present",
      data: %{"uri" => uri}
    }

    [command]
  end
end
