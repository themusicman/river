defmodule River.WorkflowsFixtures do
  def document() do
    %{
      "key" => "workflows/1",
      "steps" => [
        %{
          "label" => "Present Form",
          "key" => "system/steps/present_form/1",
          "on" => "events/123",
          "config" => %{
            "uri" => "/form",
            "form" => %{
              "emits" => "events/456",
              "schema" => %{}
            }
          }
        },
        %{
          "label" => "Process Form",
          "key" => "system/steps/process_form/2",
          "on" => "events/456",
          "config" => %{},
          "emits" => "events/789"
        },
        %{
          "label" => "Redirect User",
          "key" => "system/steps/redirect/3",
          "on" => "events/789",
          "config" => %{"url" => "https://www.google.com"}
        }
      ]
    }
  end
end
