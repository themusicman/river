defmodule RiverWeb.Graphql.Dataloader.Users do
  def data() do
    Dataloader.Ecto.new(River.Repo, query: &query/2)
  end

  # def query(Post, %{has_admin_rights: true}), do: Post
  # def query(Post, _), do: from p in Post, where: is_nil(p.deleted_at)
  # def query(queryable, _), do: queryable
  def query(queryable, _params) do
    queryable
  end
end
