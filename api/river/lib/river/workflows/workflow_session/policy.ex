defimpl Bosun.Policy, for: River.Workflows.WorkflowSession do
  @moduledoc """
  This policy defines all the authorization logic related to workflow sessions.
  """
  alias Bosun.Context

  def permitted?(
        workflow_session,
        _action,
        %{"external_identifier" => external_identifier},
        context,
        _options
      ) do
    if workflow_session.external_identifier == external_identifier do
      Context.permit(context, "Workflow session is owned by the current user")
    else
      Context.deny(context, "Workflow session is not owned by the current user")
    end
  end

  def permitted?(_resource, _action, _user, context, _options) do
    context
  end
end
