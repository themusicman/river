defmodule River.Repo do
  @moduledoc """
  The Repo manages querying the database.
  """
  use Ecto.Repo,
    otp_app: :river,
    adapter: Ecto.Adapters.Postgres
end
