# River (pre-alpha)

Workflow Engine written in Elixir and Vue

Workflows are defined via JSON configuration

```json
{
  "key": "workflows/123",
  "steps": [
    {
      "label": "Onboarding form",
      "key": "river/steps/show_page/1",
      "on": "events/123",
      "sequence": "onboarding",
      "position": 1,
      "page": {
        "slug": "form",
        "form": {
          "emits": "events/765",
          "schema": {}
        }
      },
      "config": {}
    },
    {
      "label": "Process onboarding form",
      "key": "river/steps/process_form/1",
      "sequence": "onboarding",
      "position": 2,
      "on": "events/765",
      "config": {},
      "emits": "events/777"
    },
    {
      "label": "send sms",
      "key": "river/steps/send_sms",
      "on": "events/777",
      "config": {
        "template": "thanks, {{onboarding_form.user.first_name}}"
      },
      "needs": [
        { "key": "river/steps/process_form/1", "as": "onboarding_form" }
      ]
    }
  ]
}
```

Event that triggers the process form step:

```json
{
  "key": "events/765",
  "data": {
    "user": { "first_name": "Bob" }
  }
}
```

## Todos

- [ ] Build Workflow UI (Vue SPA)
- [ ] Build Workflow Builder UI (LiveView)
- [ ] Add workflow schema validation
- [ ] Add workflow slug
- [ ] Add web hooks
