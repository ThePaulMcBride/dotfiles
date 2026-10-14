# Local Planning Statuses

Record status directly in each local ticket. Use these values when another
skill refers to a triage label:

| Skill label       | Local `Status:` value | Meaning                                  |
| ----------------- | --------------------- | ---------------------------------------- |
| `needs-triage`    | `needs-triage`        | The ticket needs evaluation              |
| `needs-info`      | `needs-info`          | More information is required             |
| `ready-for-agent` | `ready-for-agent`     | An agent can implement the ticket        |
| `ready-for-human` | `ready-for-human`     | Human implementation is required         |
| `wontfix`         | `wontfix`             | The ticket will not be implemented       |

Do not create corresponding labels in a remote service.
