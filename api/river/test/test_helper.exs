ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(River.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
Mox.defmock(RiverWeb.JWT.TokenMock, for: RiverWeb.JWT.TokenAdapter)
