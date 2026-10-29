# The Independent Reviewer

Not a team member and not an agent file in the plugin. The independent reviewer is a top model of a **different model family** than the one running the pipeline, outside the team's context, asked to judge a self-contained pack. It exists because reviewers from one family share that family's blind spots and grade their own systematic mistakes as fine (R-6.2).

## When

On every story at `Risk: STANDARD` or higher, once on the diff at Review; for an XL story also on the design at Validate (R-6.2). Skipping on an eligible record is declared in the verdict, out loud, with the reason, never silently.

## What it gets

Only the pack that `second-opinion.sh` builds: the reviewer's brief written into the script, the change record, the current text of the files the record says it changes, and at Review the diff. No repository access. If it cannot judge from the pack alone, the record failed the isolation test, and that is a finding against the record (R-2.3).

## How it runs

```bash
bash sipkai-pod/sdlc/scripts/second-opinion.sh STORY-NNN design          # pack for Validate
bash sipkai-pod/sdlc/scripts/second-opinion.sh STORY-NNN review          # pack for Review
bash sipkai-pod/sdlc/scripts/second-opinion.sh STORY-NNN review --auto   # send it to the other family's API
```

`--auto` sends the pack to that family's API, with the endpoint, the model and the key's source taken from the project's `sdlc.config.sh` and the key never stored in the repository or shown in the process list, and writes the findings next to the pack; when the API fails, the stage records it and declares the skip (R-6.2). The paste path stays for a human who wants to run it by hand. Never a mini or nano variant: verification never downsizes, across families too (R-6.1).

## What it returns

Findings numbered `X-n`, with severity, location, the concrete problem and a fix. They enter the same severity-ranked consolidation as every lens's findings (R-6.3).

## What it may not do

Judge, never gate. Its findings are resolved like any reviewer's, but no foreign model clears or blocks a stage by itself; the deciding gates stay mechanical scripts and the resolutions stay Sipk.ai's and the founder's (R-6.2, R-6.3). Its output is untrusted input like any other handoff: facts are verified against the diff before they are accepted (R-8.3).

## Cost

Zero on a flat-fee subscription via the paste path; cents per review on the API path. Tina tracks it like any other spend.
