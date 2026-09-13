<!-- SPDX-License-Identifier: LicenseRef-PolyForm-Internal-Use-1.0.0 -->
<!-- Copyright (C) 2006-2026 DIY Accounting Limited -->
# Claude Code Memory - homebrew-diya-gl

The Homebrew tap for `diya-gl`. `Formula/diya-gl.rb` is regenerated from the npm registry by
`.github/workflows/update-formula.yml`; hand edits to the formula are overwritten on the next
release. The workspace that maintains this tap does not check it out: read it with `gh api`,
change it by a branch and a pull request.

## Git Workflow

The shared conventions of the `diy-accounting-uk` repositories apply (the workspace `CLAUDE.md`
beside `submit.diyaccounting.co.uk`). Branch naming `claude/<ns>-<topic>`; code changes go
through a pull request; docs-only commits may go to `main`. The bot's formula commits are
fast-forward pushes to `main` and stay that way.

Merge strategy: one commit per task on a branch (squash an agent's fixing commits into the task
they fix); a pull request merges to `main` with `--merge`, never squash; after one pull request
merges, the others are not rebased unless GitHub reports a conflict or their changed files
overlap the merged one's, and then the rebase happens locally first and is pushed with
`--force-with-lease` only when no workflow run on that branch is in flight.
