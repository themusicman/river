defmodule River.Workflows.Token do
  @moduledoc """
  Schema for Token
  """
  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime]

  import Ecto.Query
  import Ecto.Changeset
  alias __MODULE__
  alias River.Workflows.WorkflowSession

  @hash_algorithm :sha256
  @rand_size 32

  @workflow_session_validity_in_days 1

  schema "tokens" do
    field(:token, :binary)
    field(:context, :string)
    field(:sent_to, :string)
    belongs_to(:workflow_session, WorkflowSession)

    timestamps(updated_at: false)
  end

  @doc """
  Builds a token and its hash to be delivered to the user's email.

  The non-hashed token is sent to the user email while the
  hashed part is stored in the database. The original token cannot be reconstructed,
  which means anyone with read-only access to the database cannot directly use
  the token in the application to gain access. Furthermore, if the user changes
  their email in the system, the tokens sent to the previous email are no longer
  valid.

  Users can easily adapt the existing code to provide other types of delivery methods,
  for example, by phone numbers.
  """
  def build_workflow_session_token(workflow_session) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    changeset =
      changeset(%Token{}, %{
        token: hashed_token,
        context: "workflow_session",
        sent_to: workflow_session.email,
        workflow_session_id: workflow_session.id
      })

    {Base.url_encode64(token, padding: false), changeset}
  end

  def verify_workflow_session_token_query(token) do
    context = "workflow_session"

    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)
        days = days_for_context(context)

        query =
          from(token in token_and_context_query(hashed_token, context),
            join: workflow_session in assoc(token, :workflow_session),
            where:
              token.inserted_at > ago(^days, "day") and token.sent_to == workflow_session.email,
            select: [workflow_session, token]
          )

        {:ok, query}

      :error ->
        {:error, :invalid_token}
    end
  end

  defp days_for_context("workflow_session"), do: @workflow_session_validity_in_days

  @doc """
  Returns the token struct for the given token value and context.
  """
  def token_and_context_query(token, context) do
    from(Token, where: [token: ^token, context: ^context])
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :context, :sent_to, :workflow_session_id])
    |> validate_required([:token, :context, :sent_to])
  end
end
