defmodule River.WorkflowEngine.Steps.PresentForm do
  @behaviour River.WorkflowEngine.Step
  alias River.WorkflowEngine.Commands.UICommand

  @impl River.WorkflowEngine.Step
  def handle(%{"config" => %{"form" => form, "uri" => uri}}, _event, _workflow_session) do
    command = %UICommand{
      kind: "system/forms/present",
      data: %{
        "form" => form,
        "uri" => uri
      }
    }

    [command]
  end
end
