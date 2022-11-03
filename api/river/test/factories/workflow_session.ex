defmodule River.WorkflowSessionFactory do
  defmacro __using__(_opts) do
    quote do
      alias RiverWeb.JWT.Token

      def workflow_session_factory do
        external_identifier = sequence(:external_identifier, &"external_identifier-#{&1}")

        %River.Workflows.WorkflowSession{
          external_identifier: external_identifier,
          workflow: build(:workflow),
          token: Token.token(%{external_identifier: external_identifier}),
          email: Faker.Internet.email()
        }
      end
    end
  end
end
