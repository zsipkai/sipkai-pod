# Design system

Owner: Erik. Style: clean, modern, simple, in the spirit of Apple's design: content first, generous white space, the system font stack, one accent colour, quiet motion, light and dark equal. Mocks approved by <the founder's name, date>, or the changes he asked for.

## Tokens

| Token | Light | Dark | Use |
|---|---|---|---|
| colour.text | <...> | <...> | body text |
| colour.attention | <...> | <...> | calm attention, never alarm |
| space.1 ... | <...> | | |
| type.body ... | <...> | | |

## Components

| Component | States | Accessibility | Test identifier |
|---|---|---|---|
| <Button> | default, hover, focus, disabled, busy | role, label, focus ring | `<data-testid>` |

## Vocabulary

| The product says | Never |
|---|---|
| <...> | <internal names, codes, jargon> |

## Screens of the first release

| Screen | Mock | One main message | States designed |
|---|---|---|---|
| <...> | `mocks/<screen>.html` | <...> | loading, empty, error, success |
