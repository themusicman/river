defmodule River.Workflows.Workflow do
  @moduledoc """
  The workflow is the main entity in the system. It defines the flows of events and steps that a user interacts with.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "workflows" do
    field(:key, :string)
    field(:uri, :string)
    field(:document, :map)

    has_many(:workflow_sessions, River.Workflows.WorkflowSession)

    timestamps()
  end

  @doc false
  def changeset(workflow, attrs) do
    workflow
    |> cast(attrs, [:document, :key])
    |> validate_required([:document, :key])
    |> unique_constraint(:key)
  end
end
