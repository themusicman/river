defmodule RiverWeb.Graphql.Types.PaginatedResults do
  @moduledoc """
  PaginatedResults types for Graphql API
  """
  use Absinthe.Schema.Notation

  @desc "Pagination information"
  object :pagination do
    field(:page, :integer)
    field(:page_size, :integer)
    field(:next_page, :integer)
    field(:previous_page, :integer)
    field(:total_count, :integer)
    field(:total_pages, :integer)
  end

  input_object :pagination_input do
    field(:page, non_null(:integer))
    field(:page_size, :integer)
  end
end
