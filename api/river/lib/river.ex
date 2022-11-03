defmodule River do
  @moduledoc """
  River keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def to_string(value) when is_binary(value) do
    value
  end

  def to_string(value) when is_integer(value) do
    Integer.to_string(value)
  end

  def to_string(value) when is_float(value) do
    Float.to_string(value)
  end

  def to_string(value) when is_atom(value) do
    Atom.to_string(value)
  end

  def to_string(value) when is_nil(value) do
    ""
  end

  def to_integer(value) when is_binary(value) do
    String.to_integer(value)
  end

  def to_integer(value) when is_integer(value) do
    value
  end

  def to_integer(value) when is_float(value) do
    Float.to_string(value) |> to_integer()
  end

  def to_integer(value) when is_nil(value) do
    0
  end

  @doc """
  Converts the top level keys in a map from atoms to strings

  ## Examples

      iex> River.stringify_map(%{a: 1, b: 2})
      %{"a" => 1, "b" => 2}

      iex> River.stringify_map(%{"a" => 1, "b" => 2})
      %{"a" => 1, "b" => 2}


  """
  @spec stringify_map(map()) :: map()
  def stringify_map(value) do
    value
    |> Map.new(fn
      {k, v} when is_atom(k) -> {Atom.to_string(k), v}
      {k, v} when is_binary(k) -> {k, v}
    end)
  end

  @doc """
  Returns the configuration environment

  Examples

  iex> Application.put_env(:river, :environment, :dev)
  iex> River.environment()
  :dev

  """
  def environment do
    Application.get_env(:river, :environment)
  end

  @doc """
  Returns the ui host for the SPA that is used to render the workflow
  """
  def ui_host() do
    Application.get_env(:river, :ui_host)
  end

  @doc """
  Returns the ui url based on the ui_host
  """
  def ui_url(uri \\ "/") do
    ui_host() <> uri
  end

  @doc """
  Returns the api host for the SPA that is used to render the workflow
  """
  def api_host() do
    Application.get_env(:river, :api_host)
  end

  @doc """
  Returns the frontend url based on the ui_host
  """
  def api_url(uri \\ "/") do
    api_host() <> uri
  end
end
