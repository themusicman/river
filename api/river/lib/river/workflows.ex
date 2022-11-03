defmodule River.Workflows do
  @moduledoc """
  The Workflows context.
  """

  import Ecto.Query, warn: false
  alias River.Repo
  alias River.WorkflowEngine.Commands.Command
  alias River.Workflows.{Workflow, Token, WorkflowSession}

  def handle_commands(commands, workflow_session) do
    Enum.map(commands, &Command.execute(&1, workflow_session))
  end

  def from_workflows() do
    from(w in Workflow, as: :workflows)
  end

  @doc """
  Returns the list of workflows.

  ## Examples

      iex> list_workflows()
      [%Workflow{}, ...]

  """
  def list_workflows do
    from_workflows() |> Repo.all()
  end

  @doc """
  Gets a single workflow.
  """
  def get_workflow(id), do: Repo.get(Workflow, id)

  def get_workflow_by_key(key) when is_atom(key) do
    get_workflow_by_key(Atom.to_string(key))
  end

  def get_workflow_by_key(key) do
    from_workflows() |> where(as(:workflows).key == ^key) |> Repo.one()
  end

  @doc """
  Creates a workflow.

  ## Examples

      iex> create_workflow(%{field: value})
      {:ok, %Workflow{}}

      iex> create_workflow(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workflow(attrs \\ %{}) do
    %Workflow{}
    |> Workflow.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workflow.

  ## Examples

      iex> update_workflow(workflow, %{field: new_value})
      {:ok, %Workflow{}}

      iex> update_workflow(workflow, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workflow(%Workflow{} = workflow, attrs) do
    workflow
    |> Workflow.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workflow.

  ## Examples

      iex> delete_workflow(workflow)
      {:ok, %Workflow{}}

      iex> delete_workflow(workflow)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workflow(%Workflow{} = workflow) do
    Repo.delete(workflow)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workflow changes.

  ## Examples

      iex> change_workflow(workflow)
      %Ecto.Changeset{data: %Workflow{}}

  """
  def change_workflow(%Workflow{} = workflow, attrs \\ %{}) do
    Workflow.changeset(workflow, attrs)
  end

  @doc """
  Returns the list of workflow_sessions.

  ## Examples

      iex> list_workflow_sessions()
      [%WorkflowSession{}, ...]

  """
  def list_workflow_sessions do
    Repo.all(WorkflowSession)
  end

  @doc """
  Gets a single workflow_session.

  """
  def get_workflow_session(id), do: Repo.get(WorkflowSession, id)

  @doc """
  Creates a workflow_session.

  ## Examples

      iex> create_workflow_session(%{field: value})
      {:ok, %WorkflowSession{}}

      iex> create_workflow_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workflow_session(attrs \\ %{}) do
    %WorkflowSession{}
    |> WorkflowSession.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workflow_session.

  ## Examples

      iex> update_workflow_session(workflow_session, %{field: new_value})
      {:ok, %WorkflowSession{}}

      iex> update_workflow_session(workflow_session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workflow_session(%WorkflowSession{} = workflow_session, attrs) do
    workflow_session
    |> WorkflowSession.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workflow_session.

  ## Examples

      iex> delete_workflow_session(workflow_session)
      {:ok, %WorkflowSession{}}

      iex> delete_workflow_session(workflow_session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workflow_session(%WorkflowSession{} = workflow_session) do
    Repo.delete(workflow_session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workflow_session changes.

  ## Examples

      iex> change_workflow_session(workflow_session)
      %Ecto.Changeset{data: %WorkflowSession{}}

  """
  def change_workflow_session(%WorkflowSession{} = workflow_session, attrs \\ %{}) do
    WorkflowSession.update_changeset(workflow_session, attrs)
  end

  # Workflow Session Tokens

  @doc """
  Generates a workflow sessions token to be used in magic links
  """
  def generate_workflow_session_token!(workflow_session) do
    {token, changeset} = Token.build_workflow_session_token(workflow_session)
    {:ok, token_struct} = Repo.insert(changeset)
    {token, token_struct}
  end

  @doc """
  Gets the workflow session token by the token string
  """
  def get_workflow_session_by_token(token) do
    case Token.verify_workflow_session_token_query(token) do
      {:ok, query} -> Repo.one(query)
      {:error, :invalid_token} -> [nil, nil]
    end
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_workflow_session_token(token) do
    Repo.delete_all(Token.token_and_context_query(token, "workflow_session"))
    :ok
  end
end
