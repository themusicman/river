defmodule River.WorkflowsFixtures do
  def document() do
    %{
      "key" => "workflows/1",
      "version" => 1,
      "steps" => [
        %{
          "label" => "Collect Demographics for Onboarding",
          "key" => "river/steps/show_page/1",
          "sequence" => "onboarding",
          "position" => 1,
          "page" => %{
            "slug" => "demographics",
            "title" => "Demographics",
            "description" => "Please provide your demographics",
            "form" => %{
              "emits" => "events/456",
              "schema" => %{}
            }
          },
          "on" => "events/123",
          "config" => %{}
        },
        %{
          "label" => "Process Form",
          "key" => "river/steps/process_form/1",
          "sequence" => "onboarding",
          "position" => 2,
          "on" => "events/456",
          "config" => %{},
          "emits" => "events/789"
        },
        %{
          "label" => "Consent Form",
          "key" => "river/steps/show_page/2",
          "sequence" => "onboarding",
          "position" => 3,
          "page" => %{
            "slug" => "consent",
            "title" => "Consent",
            "description" => "Please provide your consent",
            "form" => %{
              "emits" => "events/839",
              "schema" => %{}
            }
          },
          "on" => "events/789",
          "config" => %{}
        },
        %{
          "label" => "Process Form",
          "key" => "river/steps/process_form/2",
          "sequence" => "onboarding",
          "position" => 4,
          "on" => "events/839",
          "config" => %{},
          "emits" => "events/627"
        },
        %{
          "label" => "Redirect or Show Thank You Page",
          "key" => "river/steps/conditional/3",
          "sequence" => "onboarding",
          "position" => 5,
          "on" => "events/627",
          "config" => %{}
        },
        %{
          "label" => "Redirect User",
          "key" => "river/steps/redirect/3",
          "sequence" => "redirect",
          "position" => 1,
          "on" => "events/435",
          "config" => %{"url" => "https://www.google.com"}
        },
        %{
          "label" => "Show Thank You Page",
          "key" => "river/steps/show_page/3",
          "sequence" => "completed",
          "position" => 1,
          "page" => %{
            "slug" => "thank_you",
            "thank_you_message" => "Thank you for your submission"
          },
          "on" => "events/535",
          "config" => %{}
        }
      ]
    }
  end
end
