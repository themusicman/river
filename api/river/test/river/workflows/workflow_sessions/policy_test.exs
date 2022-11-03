defmodule River.WorkflowSession.Policy.Test do
  use River.DataCase

  import River.Factory
  alias RiverWeb.JWT.Token

  setup do
    workflow_session = insert(:workflow_session)
    {:ok, workflow_session: workflow_session}
  end

  test "a user is allowed to interact with a workflow_session if the external_identifier matches",
       %{
         workflow_session: workflow_session
       } do
    {:ok, claims} =
      Token.token(%{external_identifier: workflow_session.external_identifier})
      |> Token.get_claims()

    assert Bosun.permit?(claims, :interact, workflow_session) == true
  end
end
