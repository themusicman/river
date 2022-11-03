defmodule River.WorkflowFactory do
  defmacro __using__(_opts) do
    quote do
      def workflow_factory do
        %River.Workflows.Workflow{
          document: %{},
          key: sequence(:key, &"key#{&1}"),
          uri: Faker.Internet.slug()
        }
      end
    end
  end
end
