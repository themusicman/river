defmodule River.WorkflowsTest do
  use River.DataCase

  alias River.Workflows
  alias River.Workflows.{Workflow, Token, WorkflowSession}
  import River.Factory

  describe "workflows" do
    @invalid_attrs %{document: nil}

    test "list_workflows/0 returns all workflows" do
      workflow = insert(:workflow)
      assert Workflows.list_workflows() == [workflow]
    end

    test "get_workflow/1 returns the workflow with given id" do
      workflow = insert(:workflow)
      assert Workflows.get_workflow(workflow.id).id == workflow.id
    end

    test "get_workflow_by_key/1 returns the workflow with given id" do
      workflow = insert(:workflow)
      assert Workflows.get_workflow_by_key(workflow.key).id == workflow.id
    end

    test "create_workflow/1 with valid data creates a workflow" do
      valid_attrs = %{document: %{}, key: "test-key"}

      assert {:ok, %Workflow{} = workflow} = Workflows.create_workflow(valid_attrs)
      assert workflow.document == %{}
    end

    test "create_workflow/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workflows.create_workflow(@invalid_attrs)
    end

    test "update_workflow/2 with valid data updates the workflow" do
      workflow = insert(:workflow)
      update_attrs = %{document: %{}}

      assert {:ok, %Workflow{} = workflow} = Workflows.update_workflow(workflow, update_attrs)
      assert workflow.document == %{}
    end

    test "update_workflow/2 with invalid data returns error changeset" do
      workflow = insert(:workflow)
      assert {:error, %Ecto.Changeset{}} = Workflows.update_workflow(workflow, @invalid_attrs)
      assert workflow == Workflows.get_workflow(workflow.id)
    end

    test "delete_workflow/1 deletes the workflow" do
      workflow = insert(:workflow)
      assert {:ok, %Workflow{}} = Workflows.delete_workflow(workflow)
    end

    test "change_workflow/1 returns a workflow changeset" do
      workflow = insert(:workflow)
      assert %Ecto.Changeset{} = Workflows.change_workflow(workflow)
    end
  end

  describe "workflow_sessions" do
    @invalid_attrs %{external_identifier: nil}

    test "list_workflow_sessions/0 returns all workflow_sessions" do
      workflow_session = insert(:workflow_session)
      assert Enum.map(Workflows.list_workflow_sessions(), & &1.id) == [workflow_session.id]
    end

    test "get_workflow_session/1 returns the workflow_session with given id" do
      workflow_session = insert(:workflow_session)
      assert Workflows.get_workflow_session(workflow_session.id).id == workflow_session.id
    end

    test "create_workflow_session/1 with valid data creates a workflow_session" do
      workflow = insert(:workflow)

      valid_attrs = %{
        external_identifier: "some external_identifier",
        workflow_id: workflow.id,
        email: Faker.Internet.email()
      }

      assert {:ok, %WorkflowSession{} = workflow_session} =
               Workflows.create_workflow_session(valid_attrs)

      assert workflow_session.external_identifier == "some external_identifier"

      assert {:ok, %{"external_identifier" => "some external_identifier"}} =
               RiverWeb.JWT.Token.get_claims(workflow_session.token)
    end

    test "create_workflow_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workflows.create_workflow_session(@invalid_attrs)
    end

    test "update_workflow_session/2 with valid data updates the workflow_session" do
      workflow_session = insert(:workflow_session)
      update_attrs = %{external_identifier: "some updated external_identifier"}

      assert {:ok, %WorkflowSession{} = workflow_session} =
               Workflows.update_workflow_session(workflow_session, update_attrs)

      assert workflow_session.external_identifier == "some updated external_identifier"
    end

    test "update_workflow_session/2 with invalid data returns error changeset" do
      workflow_session = insert(:workflow_session)

      assert {:error, %Ecto.Changeset{}} =
               Workflows.update_workflow_session(workflow_session, @invalid_attrs)

      assert workflow_session.id == Workflows.get_workflow_session(workflow_session.id).id
    end

    test "delete_workflow_session/1 deletes the workflow_session" do
      workflow_session = insert(:workflow_session)
      assert {:ok, %WorkflowSession{}} = Workflows.delete_workflow_session(workflow_session)
    end

    test "change_workflow_session/1 returns a workflow_session changeset" do
      workflow_session = insert(:workflow_session)
      assert %Ecto.Changeset{} = Workflows.change_workflow_session(workflow_session)
    end
  end

  describe "generate_workflow_session_token!/1" do
    setup do
      %{workflow_session: insert(:workflow_session)}
    end

    test "generates a token", %{workflow_session: workflow_session} do
      {_token, token_struct} = Workflows.generate_workflow_session_token!(workflow_session)
      assert token = Repo.get_by(Token, token: token_struct.token)
      assert token.context == "workflow_session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%Token{
          token: token.token,
          workflow_session_id: insert(:workflow_session).id,
          context: "workflow_session"
        })
      end
    end
  end

  describe "delete_workflow_session_token/1" do
    test "deletes the token" do
      workflow_session = insert(:workflow_session)
      {token, token_struct} = Workflows.generate_workflow_session_token!(workflow_session)
      assert Workflows.delete_workflow_session_token(token_struct.token) == :ok
      refute Workflows.get_workflow_session_by_token(token)
    end
  end
end
