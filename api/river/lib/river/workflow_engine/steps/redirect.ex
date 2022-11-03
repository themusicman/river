defmodule River.WorkflowEngine.Steps.Redirect do
  @behaviour River.WorkflowEngine.Step
  alias River.WorkflowEngine.Commands.UICommand

  @impl River.WorkflowEngine.Step
  def run(%{"config" => %{"url" => url}}, _event, _workflow_session) do
    command = %UICommand{
      kind: "system/ui/redirect",
      data: %{
        "url" => url
      }
    }

    [command]
  end
end
