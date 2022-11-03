defmodule River.Repo.Migrations.CreateWorkflowSessions do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext", "")

    create table(:workflow_sessions) do
      add(:external_identifier, :string)
      add(:workflow_id, references(:workflows, on_delete: :nilify_all))
      add(:token, :text)
      add(:data, :map)
      add(:email, :citext, null: false)
      timestamps(type: :utc_datetime)
    end

    create(unique_index(:workflows, [:key]))
  end
end
