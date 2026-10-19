#!/usr/bin/env python3
"""Fail when a relative Markdown link points to a missing local target.

Usage: check-md-links.py [root]   (default: the repository that includes sipkai-pod/)
"""

from __future__ import annotations

import re
import sys
from pathlib import Path
from urllib.parse import unquote


ROOT = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path(__file__).resolve().parents[2]  # sipkai-pod/scripts/ -> the including repository
SKIP = {".git", "node_modules", "target", "build", "cdk.out", "dist"}
LINK = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
EXTERNAL = re.compile(r"^[a-z][a-z0-9+.-]*:", re.IGNORECASE)


def markdown_lines(path: Path):
    """Yield lines outside fenced code blocks."""
    inside_fence = False
    fence = ""
    for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        stripped = line.lstrip()
        if stripped.startswith(("```", "~~~")):
            marker = stripped[:3]
            if not inside_fence:
                inside_fence = True
                fence = marker
            elif marker == fence:
                inside_fence = False
                fence = ""
            continue
        if not inside_fence:
            yield number, line


def link_target(raw: str) -> str:
    value = raw.strip()
    if value.startswith("<") and ">" in value:
        value = value[1 : value.index(">")]
    else:
        value = value.split(maxsplit=1)[0]
    return unquote(value.split("#", 1)[0].split("?", 1)[0])


def main() -> int:
    failures: list[str] = []

    for document in sorted(ROOT.rglob("*.md")):
        if SKIP.intersection(document.parts):
            continue
        for line_number, line in markdown_lines(document):
            for match in LINK.finditer(line):
                target = link_target(match.group(1))
                if not target or target.startswith(("#", "/")) or EXTERNAL.match(target):
                    continue
                resolved = (document.parent / target).resolve()
                if not resolved.exists():
                    relative_document = document.relative_to(ROOT)
                    failures.append(f"{relative_document}:{line_number}: missing {target}")

    if failures:
        for failure in failures:
            print(f"FAIL  {failure}")
        return 1

    print("PASS  relative Markdown links resolve")
    return 0


if __name__ == "__main__":
    sys.exit(main())
