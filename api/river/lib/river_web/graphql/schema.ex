defmodule RiverWeb.Graphql.Schema do
  @moduledoc """
  Defines the GraphQL Schema.
  """
  use Absinthe.Schema
  import_types(RiverWeb.Graphql.Types.PaginatedResults)
  import_types(AbsintheErrorPayload.ValidationMessageTypes)
  import_types(Absinthe.Type.Custom)
  import_types(RiverWeb.Graphql.Types.Workflows)

  query do
  end

  mutation do
    import_fields(:workflow_mutations)
  end

  def context(context) do
    loader = Dataloader.new()
    # |> Dataloader.add_source(Users, Users.data())

    Map.put(context, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
