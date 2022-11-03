defmodule River.Factory do
  use ExMachina.Ecto, repo: River.Repo
  use River.WorkflowFactory
  use River.WorkflowSessionFactory
end
