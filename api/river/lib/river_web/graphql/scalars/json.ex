defmodule RiverWeb.Graphql.Scalars.Json do
  @moduledoc """
  Scalar type for JSON
  """
  use Absinthe.Schema.Notation

  scalar :json, name: "JSON" do
    serialize(&serialize_json/1)
    parse(&parse_json/1)
  end

  @spec parse_json(Absinthe.Blueprint.Input.Null.t() | Absinthe.Blueprint.Input.String.t()) ::
          {:ok, nil} | {:ok, DateTime.t()} | :error
  defp parse_json(%Absinthe.Blueprint.Input.String{value: value}) do
    case Jason.decode(value) do
      {:ok, json} -> {:ok, json}
      {:error, _} -> :error
    end
  end

  defp parse_json(%Absinthe.Blueprint.Input.Null{}), do: {:ok, nil}

  defp parse_json(_), do: :error

  defp serialize_json(value), do: value
end
