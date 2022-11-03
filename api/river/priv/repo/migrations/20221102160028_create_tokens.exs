defmodule River.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add(:workflow_session_id, references(:workflow_sessions, on_delete: :delete_all))

      add(:token, :binary, null: false)
      add(:context, :string, null: false)
      add(:sent_to, :string)
      timestamps(updated_at: false, type: :utc_datetime)
    end

    create(index(:tokens, [:workflow_session_id]))
    create(unique_index(:tokens, [:context, :token]))
  end
end
