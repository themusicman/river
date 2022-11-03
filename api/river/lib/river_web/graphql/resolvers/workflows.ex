defmodule RiverWeb.Graphql.Resolvers.Workflows do
  @moduledoc """
  Resolver for Workflows
  """
  require Logger
  alias RiverWeb.Graphql.RespondWith.Mutation
  alias River.Workflows
  alias River.WorkflowEngine

  def create_workflow_session(_parent, %{workflow_session: workflow_session}, _resolution) do
    with {:workflow, workflow} when not is_nil(workflow) <-
           {:workflow, Workflows.get_workflow_by_key(workflow_session[:workflow_key])},
         {:ok, workflow_session} <-
           Workflows.create_workflow_session(%{
             workflow_id: workflow.id,
             external_identifier: workflow_session[:external_identifier],
             email: workflow_session[:email]
           }),
         {:ok, magic_link} <-
           generate_magic_link(workflow_session) do
      Mutation.success(%{magic_link: magic_link, workflow_session: workflow_session})
    else
      {:workflow, nil} ->
        Mutation.not_found("Workflow not found")
    end
  end

  defp generate_magic_link(workflow_session) do
    try do
      {token, _token_struct} = Workflows.generate_workflow_session_token!(workflow_session)
      {:ok, River.api_url("/v/" <> token)}
    rescue
      e ->
        Logger.error("Error generating magic link: #{inspect(e)}")
        {:error, "Error generating magic link"}
    end
  end

  def trigger_event(_parent, %{event: event}, _resolution) do
    with {:workflow_session, workflow_session} when not is_nil(workflow_session) <-
           {:workflow_session, Workflows.get_workflow_session(event[:workflow_session_id])},
         {:workflow, workflow} when not is_nil(workflow) <-
           {:workflow, Workflows.get_workflow(workflow_session.workflow_id)} do
      event = River.stringify_map(event)

      _result =
        WorkflowEngine.handle_event(workflow, event, workflow_session)
        |> WorkflowEngine.handle_commands(workflow_session)

      # Probably should return the results of the handle_event function
      Mutation.success(workflow_session)
    else
      {:workflow_session, nil} ->
        Mutation.not_found("Workflow session not found")

      {:workflow, nil} ->
        Mutation.not_found("Workflow not found")
    end
  end
end
