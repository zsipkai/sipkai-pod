# The Independent Reviewer

Not a team member and not an agent file in the plugin. The independent reviewer is a top model of a **different model family** than the one running the pipeline, outside the team's context, asked to judge a self-contained pack. It exists because reviewers from one family share that family's blind spots and grade their own systematic mistakes as fine (R-6.7).

## When

On every change record at `Risk: STANDARD` or higher, twice: once at Validate on the design, once at Review on the diff. Skipping on an eligible record is declared in the verdict, out loud, never silently.

## What it gets

Only the pack that `second-opinion.sh` builds: the charter, the change record, and at Review the diff. No repository access. If it cannot judge from the pack alone, the record failed the isolation test, and that is a finding against the record (R-6.8).

## How it runs

```bash
bash sipkai-pod/scripts/second-opinion.sh STORY-NNN design          # pack for Validate
bash sipkai-pod/scripts/second-opinion.sh STORY-NNN review          # pack for Review
bash sipkai-pod/scripts/second-opinion.sh STORY-NNN review --auto   # send it to the other family's API
```

The paste path: the founder pastes the pack into the other family's top model and pastes the findings back. The automatic path: `--auto` sends the pack to that family's API, with the key read at run time from a fixed Keychain item and never stored in the repository or shown in the process list, and writes the findings next to the pack. Never a mini or nano variant: verification never downsizes, across families too (R-6.12).

## What it returns

Findings numbered `X-n`, with severity, location, the concrete problem and a fix. They enter the same severity-ranked consolidation as every lens's findings (R-6.9).

## What it may not do

Judge, never gate. No foreign model clears or blocks a stage by itself; the deciding gates stay mechanical scripts and the resolutions stay Sipk.ai's and the founder's (R-6.7). Its output is untrusted input like any other handoff: facts are verified against the diff before they are accepted (R-8.7).

## Cost

Zero on a flat-fee subscription via the paste path; cents per review on the API path. Tina tracks it like any other spend.
