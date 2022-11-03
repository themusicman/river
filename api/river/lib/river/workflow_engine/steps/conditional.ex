defmodule River.WorkflowEngine.Steps.Conditional do
  @behaviour River.WorkflowEngine.Step
  alias River.WorkflowEngine.Commands.NextEventCommand

  @impl River.WorkflowEngine.Step
  def run(%{"config" => config, "needs" => needs}, event, workflow_session) do
    data = build_data(event, workflow_session, needs)
    # evaluate the cases and first match wins

    match =
      Map.get(config, "conditions", [])
      |> Enum.find(nil, &evaluate_condition(&1, data))

    if match do
      [
        %NextEventCommand{
          event: %{
            "key" => match["emits"],
            "data" => Map.take(match, ["key", "operation", "left", "right"])
          }
        }
      ]
    else
      []
    end
  end

  @doc """
  Evaluates whether a condition is true or false
  """
  def evaluate_condition(condition, data) do
    case condition do
      %{"operation" => operation, "left" => left, "right" => right} ->
        left = get_value(data, left)
        right = get_value(data, right)

        case operation do
          "eq" -> left == right
          "neq" -> left != right
          "gt" -> left > right
          "gte" -> left >= right
          "lt" -> left < right
          "lte" -> left <= right
          "contains" -> String.contains?(left, right)
          "not_contains" -> not String.contains?(left, right)
          "starts_with" -> String.starts_with?(left, right)
          "not_starts_with" -> not String.starts_with?(left, right)
          "ends_with" -> String.ends_with?(left, right)
          "not_ends_with" -> not String.ends_with?(left, right)
          "is_empty" -> left == ""
          "is_not_empty" -> left != ""
          "is_null" -> left == nil
          "is_not_null" -> left != nil
          "is_true" -> left == true
          "is_false" -> left == false
          "is_not_true" -> left != true
          "is_not_false" -> left != false
          "is_in" -> Enum.member?(right, left)
          "is_not_in" -> not Enum.member?(right, left)
          "is_in_range" -> left >= Enum.at(right, 0) and left <= Enum.at(right, 1)
          "is_not_in_range" -> left < Enum.at(right, 0) or left > Enum.at(right, 1)
        end

      _ ->
        # error
        false
    end
  end

  @doc """
  Returns the value of the given path in the given data map. If the path doesn't contain a period it returns itself.
  """
  @spec get_value(map(), String.t() | number()) :: any()
  def get_value(data, path) when is_binary(path) do
    if String.contains?(path, "."),
      do: get_in(data, String.split(path, ".")),
      else: path
  end

  def get_value(_data, path) when not is_binary(path) do
    path
  end

  @doc """
  Builds a data map from the session data and the event data.
  """
  def build_data(event, workflow_session, needs) do
    Enum.reduce(
      needs,
      %{
        "event" => event["data"]
      },
      fn need, acc ->
        key = need["key"]
        datum = Map.get(workflow_session.data, key, nil)

        if datum do
          data_key = needs["as"] || String.replace(key, "/", "_")
          Map.put(acc, data_key, datum)
        else
          acc
        end
      end
    )
  end
end
