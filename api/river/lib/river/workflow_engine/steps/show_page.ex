defmodule River.WorkflowEngine.Steps.ShowPage do
  @behaviour River.WorkflowEngine.Step
  alias River.WorkflowEngine.Commands.UICommand

  @impl River.WorkflowEngine.Step
  def run(%{"config" => %{"page" => page}}, _event, _workflow_session) do
    command = build_ui_command(page)
    [command]
  end

  def build_ui_command(page) do
    %UICommand{
      kind: "system/pages/show",
      data: %{"page" => page}
    }
  end
end
