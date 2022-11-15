defmodule River.Steps.Conditional.Test do
  use River.DataCase

  import River.Factory
  alias River.Steps.Conditional
  alias River.WorkflowEngine.Commands.NextEventCommand

  describe "get_value/2" do
    test "returns itself if no path given" do
      assert Conditional.get_value(%{}, "foo") == "foo"
    end

    test "returns the value at the path if a path is given" do
      assert Conditional.get_value(%{"event" => %{"name" => "Betty"}}, "event.name") == "Betty"
    end
  end

  describe "run/2" do
    setup do
      workflow_session = insert(:workflow_session)

      {:ok, workflow_session: workflow_session}
    end

    test "returns a next event command for the first match if left is equal to right", %{
      workflow_session: workflow_session
    } do
      event = %{"key" => "events/222", "data" => %{"first_name" => "John", "last_name" => "Doe"}}

      step = %{
        "label" => "Conditional Logic",
        "key" => "river/steps/conditional/1",
        "on" => "events/222",
        "config" => %{
          "conditions" => [
            %{
              "key" => "cases/111",
              "emits" => "events/333",
              "operation" => "eq",
              # form_one.first_name 
              "left" => "event.first_name",
              "right" => "John"
            },
            %{
              "key" => "cases/222",
              "emits" => "events/555",
              "operation" => "eq",
              "left" => "first_name",
              "right" => "Bill"
            }
          ]
        },
        "needs" => [%{"key" => "river/steps/process_form/1", "as" => "form_one"}]
      }

      assert Conditional.run(step, event, workflow_session) ==
               [
                 %NextEventCommand{
                   event: %{
                     "key" => "events/333",
                     "data" => %{
                       "key" => "cases/111",
                       "operation" => "eq",
                       "left" => "event.first_name",
                       "right" => "John"
                     }
                   }
                 }
               ]
    end

    test "returns a next event command for the first match if second condition is the match", %{
      workflow_session: workflow_session
    } do
      event = %{"key" => "events/222", "data" => %{"first_name" => "Bill", "last_name" => "Doe"}}

      step = %{
        "label" => "Conditional Logic",
        "key" => "river/steps/conditional/1",
        "on" => "events/222",
        "config" => %{
          "conditions" => [
            %{
              "key" => "cases/111",
              "emits" => "events/333",
              "operation" => "eq",
              "left" => "event.first_name",
              "right" => "John"
            },
            %{
              "key" => "cases/222",
              "emits" => "events/555",
              "operation" => "eq",
              "left" => "event.first_name",
              "right" => "Bill"
            }
          ]
        },
        "needs" => [%{"key" => "river/steps/process_form/1", "as" => "form_one"}]
      }

      assert Conditional.run(step, event, workflow_session) ==
               [
                 %NextEventCommand{
                   event: %{
                     "key" => "events/555",
                     "data" => %{
                       "key" => "cases/222",
                       "operation" => "eq",
                       "left" => "event.first_name",
                       "right" => "Bill"
                     }
                   }
                 }
               ]
    end
  end

  describe "evaluate_condition/2" do
    test "when operation is eq it returns false if left is not equal to right" do
      condition = %{
        "key" => "cases/111",
        "emits" => "events/333",
        "operation" => "eq",
        "left" => "event.first_name",
        "right" => "John"
      }

      data = %{"event" => %{"first_name" => "Bob", "last_name" => "Doe"}}

      assert Conditional.evaluate_condition(condition, data) == false
    end

    test "when the operation is eq it returns true if left is equal to right" do
      condition = %{
        "key" => "cases/111",
        "emits" => "events/333",
        "operation" => "eq",
        "left" => "event.first_name",
        "right" => "John"
      }

      data = %{"event" => %{"first_name" => "John", "last_name" => "Doe"}}

      assert Conditional.evaluate_condition(condition, data) == true
    end

    test "when operation is neq it returns true if left is not equal to right" do
      condition = %{
        "key" => "cases/111",
        "emits" => "events/333",
        "operation" => "neq",
        "left" => "event.first_name",
        "right" => "John"
      }

      data = %{"event" => %{"first_name" => "Bob", "last_name" => "Doe"}}

      assert Conditional.evaluate_condition(condition, data) == true
    end

    test "when the operation is neq it returns false if left is equal to right" do
      condition = %{
        "key" => "cases/111",
        "emits" => "events/333",
        "operation" => "neq",
        "left" => "event.first_name",
        "right" => "John"
      }

      data = %{"event" => %{"first_name" => "John", "last_name" => "Doe"}}

      assert Conditional.evaluate_condition(condition, data) == false
    end

    test "when operation is gt it returns true if left is greater than the right" do
      condition = %{
        "key" => "cases/111",
        "emits" => "events/333",
        "operation" => "gt",
        "left" => "event.age",
        "right" => 19
      }

      data = %{"event" => %{"first_name" => "Bob", "age" => 30}}

      assert Conditional.evaluate_condition(condition, data) == true
    end

    test "when the operation is gt it returns false if left is not greater than the right" do
      condition = %{
        "key" => "cases/111",
        "emits" => "events/333",
        "operation" => "gt",
        "left" => "event.age",
        "right" => 33
      }

      data = %{"event" => %{"first_name" => "Bob", "age" => 30}}

      assert Conditional.evaluate_condition(condition, data) == false
    end
  end
end
