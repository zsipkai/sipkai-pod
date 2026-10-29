#!/usr/bin/env bash
# Card, board and record agree (R-3.6; SI-025, SI-040, SI-045, SI-062, SI-086).
#
# For every change record, its story card and its board rows must say the
# same thing as the record: the card's "(Stage X)" pointer and Status, the
# card's proposed execution model, and the board's Stage, Tier and Budget
# cells. Phrases of a retired route or tool, listed by the project in
# SDLC_RETIRED_PHRASES, may not appear in the truth files, the open stories
# or the board (a DONE card's dated notes are history). A drift class that recurs gets a line here, not another
# reviewer run.
#
# CHECK_RECORDS_DIR, CHECK_STORIES_DIR and CHECK_BOARD override the folders
# (the process evaluations use a throwaway project).

set -uo pipefail
source "$(dirname "$0")/lib.sh"
export DRIFT_RECORDS="${CHECK_RECORDS_DIR:-$SDLC_RECORDS_DIR}"
export DRIFT_STORIES="${CHECK_STORIES_DIR:-$SDLC_STORIES_DIR}"
export DRIFT_BOARD="${CHECK_BOARD:-${SDLC_BOARD:-}}"
export DRIFT_RETIRED="$(printf '%s\n' "${SDLC_RETIRED_PHRASES[@]:-}")"
export DRIFT_TRUTH="$(printf '%s\n' "${SDLC_TRUTH_FILES[@]:-}")"

python3 -I - <<'PY'
import glob, os, re, sys

records, stories, board = os.environ["DRIFT_RECORDS"], os.environ["DRIFT_STORIES"], os.environ["DRIFT_BOARD"]
fails = []

def tokens(budget):
    m = re.match(r"\s*([0-9]+(?:\.[0-9]+)?)\s*([kKmM]?)", budget or "")
    if not m: return None
    n, u = float(m.group(1)), m.group(2).lower()
    return int(round(n * (1000 if u == "k" else 1000000 if u == "m" else 1)))

def field(text, name):
    m = re.search(r"^" + re.escape(name) + r":\s*(.+)$", text, re.M)
    return m.group(1).strip() if m else ""

recs = {}
for path in sorted(glob.glob(os.path.join(records, "STORY-*.md"))):
    sid = os.path.basename(path)[:-3]
    if not re.fullmatch(r"STORY-\d+", sid): continue
    t = open(path, encoding="utf-8").read()
    recs[sid] = dict(stage=field(t, "Stage").split()[0] if field(t, "Stage") else "",
                     tier=(field(t, "Execution model").split() or [""])[0],
                     budget=tokens(field(t, "Budget")))

for sid, r in recs.items():
    cards = glob.glob(os.path.join(stories, sid + "-*.md"))
    if not cards: continue
    card = open(cards[0], encoding="utf-8").read(); cname = os.path.basename(cards[0])
    m = re.search(r"^- Change record:.*\(Stage ([A-Z-]+)\)", card, re.M)
    if m and m.group(1) != r["stage"]:
        fails.append(f"{cname}: says (Stage {m.group(1)}), the record says {r['stage']}")
    status = field(card, "- Status")
    if (status.split() or [""])[0] == "DONE" and r["stage"] != "DEPLOYED":
        fails.append(f"{cname}: Status DONE, but the record is at {r['stage']}")
    if r["stage"] == "DEPLOYED" and status and (status.split() or [""])[0] != "DONE":
        fails.append(f"{cname}: the record is DEPLOYED, but the card's Status is {status.split()[0]}")
    m = re.search(r"^- Proposed execution model:\s*(\w+)", card, re.M)
    if m and r["tier"] and m.group(1) != r["tier"]:
        fails.append(f"{cname}: proposed execution model {m.group(1)}, the record routes {r['tier']}")

if board and os.path.isfile(board):
    header = None
    for n, line in enumerate(open(board, encoding="utf-8"), 1):
        if not line.startswith("|"): header = None; continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if all(re.fullmatch(r":?-+:?", c) for c in cells if c): continue
        if header is None:
            header = {c: i for i, c in enumerate(cells)}; continue
        ids = [x for x in re.findall(r"STORY-\d+", " ".join(cells[:3])) if x in recs]
        if not ids: continue
        sid, r = ids[0], recs[ids[0]]
        def cell(name):
            i = header.get(name); return cells[i] if i is not None and i < len(cells) else None
        stage = cell("Stage")
        if stage and stage not in ("—", "-") and stage.split()[0] != r["stage"]:
            fails.append(f"{os.path.basename(board)}:{n}: {sid} Stage '{stage.split()[0]}', the record says {r['stage']}")
        tier = cell("Tier")
        if tier and tier not in ("—", "-") and r["tier"] and tier.split()[0] != r["tier"]:
            fails.append(f"{os.path.basename(board)}:{n}: {sid} Tier '{tier}', the record routes {r['tier']}")
        budget = cell("Budget")
        if budget and budget not in ("—", "-") and r["budget"] and tokens(budget) != r["budget"]:
            fails.append(f"{os.path.basename(board)}:{n}: {sid} Budget '{budget}', the record says {r['budget']:,} tokens")

phrases = [p for p in os.environ["DRIFT_RETIRED"].split("\n") if p.strip()]
if phrases:
    files = [f for f in os.environ["DRIFT_TRUTH"].split("\n") if f.strip()]
    for c in glob.glob(os.path.join(stories, "*.md")):
        head = open(c, encoding="utf-8").read(2000)
        if not re.search(r"^- Status:\s*DONE", head, re.M):   # a finished story's dated notes are history
            files.append(c)
    if board: files.append(board)
    for f in sorted(set(files)):
        if not os.path.isfile(f): continue
        for n, line in enumerate(open(f, encoding="utf-8"), 1):
            if "SDLC_RETIRED_PHRASES" in line: continue   # the list itself
            for p in phrases:
                if p.lower() in line.lower():
                    fails.append(f"{f}:{n}: retired phrase '{p}' (SDLC_RETIRED_PHRASES)")

for f in fails: print("FAIL  " + f)
if not fails: print(f"PASS  {len(recs)} change records agree with their cards and the board")
sys.exit(1 if fails else 0)
PY
