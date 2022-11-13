defmodule River.WorkflowsFixtures do
  def document() do
    %{
      "key" => "workflows/1",
      "steps" => [
        %{
          "label" => "Present Form",
          "key" => "system/steps/show_page/1",
          "on" => "events/123",
          "config" => %{
            "page" => %{
              "uri" => "/form",
              "title" => "My Form",
              "description" => "This is my form",
              "form" => %{
                "emits" => "events/456",
                "schema" => %{}
              }
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
          "label" => "Redirect or Show Thank You Page",
          "key" => "system/steps/conditional/3",
          "on" => "events/789",
          "config" => %{}
        },
        %{
          "label" => "Redirect User",
          "key" => "system/steps/redirect/3",
          "on" => "events/789",
          "config" => %{"url" => "https://www.google.com"}
        },
        %{
          "label" => "Show Thank You Page",
          "key" => "system/steps/show_page/1",
          "on" => "events/777",
          "config" => %{
            "page" => %{
              "uri" => "/thank-you",
              "thank_you_message" => "Thank you for your submission"
            }
          }
        }
      ]
    }
  end
end
