defmodule RiverWeb.MagicLinksController do
  use RiverWeb, :controller
  import RiverWeb.Controllers.CookieAuth
  alias River.Workflows
  alias River.Repo

  def verify(conn, params) do
    [workflow_session, _] = Workflows.get_workflow_session_by_token(params["token"])

    if workflow_session do
      workflow_session = workflow_session |> Repo.preload(:workflow)
      workflow = workflow_session.workflow

      conn
      |> write_jwt_cookie(workflow_session)
      |> redirect(external: River.ui_url("/#{workflow.uri}"))
    else
      conn
      |> put_flash(:error, "Token expired")
      |> redirect(to: "/")
    end
  end
end
