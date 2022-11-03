defmodule River.Workflows.WorkflowSession do
  @moduledoc """
  The Workflow session represents a single instance of a workflow. It is created
  when a workflow is started. It also holds the data that is collected during a session.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias RiverWeb.JWT.Token

  schema "workflow_sessions" do
    field(:external_identifier, :string)
    field(:token, :string)
    field(:email, :string)
    field(:data, :map, default: %{})
    belongs_to(:workflow, River.Workflows.Workflow)

    timestamps()
  end

  @doc false
  def create_changeset(workflow_session, attrs) do
    workflow_session
    |> cast(attrs, [:external_identifier, :workflow_id, :email])
    |> validate_required([:external_identifier, :workflow_id, :email])
    |> assoc_constraint(:workflow)
    |> put_change(:token, Token.token(%{external_identifier: attrs[:external_identifier]}))
  end

  def update_changeset(workflow_session, attrs) do
    workflow_session
    |> cast(attrs, [:external_identifier, :workflow_id, :data, :token, :email])
    |> validate_required([:external_identifier, :workflow_id, :email])
    |> assoc_constraint(:workflow)
  end
end
