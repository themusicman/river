# River (pre-alpha)

Workflow Engine written in Elixir and Vue

Workflows are defined via JSON configuration

```json
{
  "key": "workflows/123",
  "steps": [
    {
      "label": "present form",
      "key": "system/steps/present_form/1",
      "on": "events/123",
      "config": {
        "form": {
          "uri": "/form",
          "emits": "events/765",
          "schema": {}
        }
      }
    },
    {
      "label": "process form",
      "key": "system/steps/process_form/1",
      "on": "events/765",
      "config": {},
      "emits": "events/777"
    },
    {
      "label": "send sms",
      "key": "system/steps/send_sms",
      "on": "events/777",
      "config": {
        "template": "thanks, {{user.first_name}}"
      },
      "needs": [{ "key": "system/steps/process_form/1", "as": "form_1" }] // provides data from another step to this step
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
