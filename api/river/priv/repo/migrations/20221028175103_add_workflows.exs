defmodule River.Repo.Migrations.AddWorkflows do
  use Ecto.Migration

  def change do
    create table(:workflows) do
      add(:document, :map)
      add(:key, :string)
      add(:uri, :string)

      timestamps(type: :utc_datetime)
    end
  end
end
