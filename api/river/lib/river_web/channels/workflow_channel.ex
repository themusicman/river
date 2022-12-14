defmodule RiverWeb.WorkflowChannel do
  use RiverWeb, :channel

  alias River.Repo
  alias River.WorkflowEngine.Steps
  alias River.Steps.ShowPage

  @impl true
  def join("workflow:" <> workflow_session_id, payload, socket) do
    with {:ok, _claims} <- check_auth(payload),
         {:workflow_session, workflow_session} when not is_nil(workflow_session) <-
           {:workflow_session,
            River.Workflows.get_workflow_session(workflow_session_id) |> Repo.preload(:workflow)} do
      socket =
        socket
        |> assign(:workflow_session, workflow_session)

      {:ok, socket}
    else
      {:workflow_session, nil} ->
        {:error, %{reason: "Workflow session not found"}}

      _ ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("trigger_event", event, socket) do
    workflow_session = socket.assigns.workflow_session

    River.WorkflowEngine.handle_event(workflow_session.workflow, event, workflow_session)
    |> River.WorkflowEngine.execute_commands(workflow_session)

    {:reply, {:ok, %{"success" => true}}, socket}
  end

  @impl true
  def handle_in("request_page", event, socket) do
    workflow_session = socket.assigns.workflow_session

    step = Steps.find_step_with_uri(workflow_session.workflow, event["uri"])

    if step do
      [ShowPage.build_ui_command(step)]
      |> River.WorkflowEngine.execute_commands(workflow_session)
    end

    {:reply, {:ok, %{"success" => true}}, socket}
  end

  defp jwt() do
    Application.get_env(:river, :jwt)
  end

  defp check_auth(%{"token" => token}) do
    case jwt().get_claims(token) do
      {:ok, claims} ->
        {:ok, claims}

      {:error, _} ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  defp check_auth(_) do
    {:error, %{reason: "unauthorized"}}
  end
end
