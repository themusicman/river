defmodule River.WorkflowEngine.Steps do
  @moduledoc """
  The Steps module is responsible executing the steps.
  """

  def find_step_with_uri(workflow, uri) do
    workflow.document
    |> get_in(["steps"])
    |> Enum.filter(fn step ->
      get_in(step, ["config", "page", "uri"]) == uri
    end)
    |> List.first(nil)
  end

  def get_all_for_event(workflow, event) do
    workflow.document
    |> get_in(["steps"])
    |> Enum.filter(fn step ->
      step["on"] == event["key"]
    end)
  end

  @spec event_from_step(map) :: binary() | nil
  def event_from_step(%{"emits" => event}) when not is_nil(event) do
    event
  end

  def event_from_step(%{"config" => %{"page" => %{"form" => %{"emits" => event}}}})
      when not is_nil(event) do
    event
  end

  def event_from_step(_event) do
    nil
  end

  def run(step, event, workflow_session) do
    impl = get_impl_for_key(step["key"])
    impl.run(step, event, workflow_session)
  end

  def get_impl_for_key("system/steps/show_page/" <> _id),
    do: Application.get_env(:river, :show_page)

  def get_impl_for_key("system/steps/process_form/" <> _id),
    do: Application.get_env(:river, :process_form)

  def get_impl_for_key("system/steps/redirect/" <> _id),
    do: Application.get_env(:river, :redirect)

  def get_impl_for_key("system/steps/stop/" <> _id),
    do: Application.get_env(:river, :stop)
end
