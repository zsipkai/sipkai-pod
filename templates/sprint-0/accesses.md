# Accesses

Every access the work needs. Secrets never live in the repository, a file the gate scans, or a chat.

| Access | For | Created by | Where the secret lives | Authority given to the pod | Checked with | Status |
|---|---|---|---|---|---|---|
| Source repository | the code and the workspace | <founder> | <none: SSH key or credential helper> | push to the default branch after the gate | `git ls-remote` | <granted, date> |
| Cloud account (development) | the development environment | <founder> | <the cloud's own sign-in> | create and change development resources inside an approved story | <read-only command> | <...> |
| Second model family API | the independent reviewer | <founder> | <Keychain item> | review packs only | `second-opinion.sh --auto` on a fixture | <...> |

## Deny rules in the harness settings

<The commands and folders no agent may touch, and the date each rule was tested (R-8.1).>

## What only the founder may do

Production, billing, account settings, permission widening at account level, deletions (R-5.2).
