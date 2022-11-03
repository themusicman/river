defmodule River.WorkflowEngine.Step do
  @moduledoc """
  A step is a module that implements the `handle/2` function. The `handle/2` function takes two arguments: the step configuration and the event that triggered the step. The `handle/2` function returns a list of commands that will be executed by the logic engine.
  """
  alias River.WorkflowEngine.Commands.Command.{UICommand, StopCommand, NextEventCommand}

  @typedoc """
  The step configuration.
  """
  @type step :: map()

  @typedoc """
  The event that triggers a step.
  """
  @type event :: map()

  @callback run(step(), event(), WorkflowSession.t()) :: [
              UICommand.t()
              | NextEventCommand.t()
              | StopCommand.t()
            ]
end
