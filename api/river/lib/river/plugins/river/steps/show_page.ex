defmodule River.Steps.ShowPage do
  @behaviour River.WorkflowEngine.Step
  alias River.WorkflowEngine.Commands.UICommand

  @impl River.WorkflowEngine.Step
  def run(step, _event, _workflow_session) do
    command = build_ui_command(step)
    [command]
  end

  def build_ui_command(step) do
    %UICommand{
      kind: "river/pages/show",
      data: %{
        "sequence" => step["sequence"],
        "position" => step["position"],
        "page" => step["page"]
      }
    }
  end
end
