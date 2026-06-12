#!/usr/bin/env python3
"""Command-line entry point for the human exception workflow example."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from common import get_client
from human_exception_workflow.workflow import print_summary, run_workflow


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run the Metatate human exception workflow example.")
    parser.add_argument(
        "--output",
        default="/private/tmp/metatate-human-exception-workflow-report.json",
        help="Path for the machine-readable workflow report.",
    )
    parser.add_argument(
        "--fail-on-blocked",
        action="store_true",
        help="Return a non-zero exit code when any request remains blocked by policy.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    run = run_workflow(get_client())
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(run.to_dict(), indent=2) + "\n", encoding="utf-8")
    print_summary(run)
    print(f"Wrote human exception workflow report to {output_path}")
    if args.fail_on_blocked and run.blocked_by_policy:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
