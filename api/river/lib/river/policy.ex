defimpl Bosun.Policy, for: Any do
  @moduledoc """
  The fallback authorization policy.
  """
  alias Bosun.Context

  def permitted?(_resource, _action, _subject, context, _options) do
    Context.deny(context, "Impermissible")
  end
end
