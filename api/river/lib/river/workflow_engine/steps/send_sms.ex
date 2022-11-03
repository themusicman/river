defmodule River.WorkflowEngine.Steps.SendSms do
  @behaviour River.WorkflowEngine.Step

  @impl River.WorkflowEngine.Step
  def run(%{"meta" => _meta}, _event, _workflow_session) do
  end
end
