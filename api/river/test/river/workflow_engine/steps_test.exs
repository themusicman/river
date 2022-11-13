defmodule River.WorkflowEngine.Steps.Test do
  use River.DataCase

  import River.Factory
  alias River.WorkflowEngine.Steps
  alias River.WorkflowsFixtures
  alias River.WorkflowEngine.Commands.{UICommand, NextEventCommand}

  setup do
    document = WorkflowsFixtures.document()
    workflow = insert(:workflow, document: document)
    workflow_session = insert(:workflow_session, workflow: workflow)

    {:ok, workflow: workflow, workflow_session: workflow_session}
  end

  describe "find_step_with_uri/2" do
    test "returns the step that has a uri", %{workflow: workflow} do
      uri = "/form"

      assert Steps.find_step_with_uri(workflow, uri) == %{
               "config" => %{
                 "page" => %{
                   "description" => "This is my form",
                   "form" => %{"emits" => "events/456", "schema" => %{}},
                   "title" => "My Form",
                   "uri" => "/form"
                 }
               },
               "key" => "system/steps/show_page/1",
               "label" => "Present Form",
               "on" => "events/123"
             }
    end

    test "returns nil if there is no step with that uri", %{workflow: workflow} do
      uri = "/form1"

      assert Steps.find_step_with_uri(workflow, uri) == nil
    end
  end

  describe "get_all_for_event/2" do
    test "returns all steps for an event", %{workflow: workflow} do
      event = %{"key" => "events/123"}
      assert length(Steps.get_all_for_event(workflow, event)) == 1
    end
  end

  describe "event_from_step/1" do
    test "returns the event in the emits key" do
      step = %{
        "label" => "Process Form",
        "key" => "system/steps/process_form/2",
        "on" => "events/999",
        "config" => %{},
        "emits" => "events/777"
      }

      assert Steps.event_from_step(step) == "events/777"
    end

    test "returns event for a form" do
      step = %{
        "label" => "Show Form",
        "key" => "system/steps/show_page/1",
        "on" => "events/222",
        "config" => %{"page" => %{"uri" => "/form", "form" => %{"emits" => "events/333"}}}
      }

      assert Steps.event_from_step(step) == "events/333"
    end
  end

  describe "run/2" do
    test "executes the a show form step and returns a ui command", %{
      workflow_session: workflow_session
    } do
      step = %{
        "label" => "Show Form",
        "key" => "system/steps/show_page/1",
        "on" => "events/222",
        "config" => %{"page" => %{"form" => %{"emits" => "events/333"}, "uri" => "/form"}}
      }

      event = %{"key" => "events/222"}

      assert Steps.run(step, event, workflow_session) == [
               %UICommand{
                 data: %{"page" => %{"form" => %{"emits" => "events/333"}, "uri" => "/form"}},
                 kind: "system/pages/show"
               }
             ]
    end

    test "executes the a show form step and returns an event", %{
      workflow_session: workflow_session
    } do
      step = %{
        "label" => "Process Form",
        "key" => "system/steps/process_form/2",
        "on" => "events/222",
        "config" => %{},
        "emits" => "events/333"
      }

      event = %{"key" => "events/222", "data" => %{"foo" => "bar"}}

      assert Steps.run(step, event, workflow_session) == [
               %NextEventCommand{event: %{"key" => "events/333"}}
             ]
    end

    test "executes the a redirect step and returns a ui command", %{
      workflow_session: workflow_session
    } do
      url = "https://example.com"

      step = %{
        "label" => "Redirect",
        "key" => "system/steps/redirect/1",
        "on" => "events/222",
        "config" => %{"url" => url}
      }

      event = %{"key" => "events/222", "data" => %{"foo" => "bar"}}

      assert Steps.run(step, event, workflow_session) == [
               %UICommand{
                 data: %{"url" => "https://example.com"},
                 kind: "system/ui/redirect"
               }
             ]
    end
  end
end
