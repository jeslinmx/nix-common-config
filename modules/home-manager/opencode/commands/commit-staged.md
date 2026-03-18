---
description: Prepare a git commit based on the staged files
---

1. Inspect the git index.
2. Summarize staged changes into a commit summary and description.
   - Comply with project-specific commit style conventions (in agent instructions, readmes, or precedent set by prior commits)
   - If no established convention exists, follow standard good practices:
     - Commit summary follows Conventional Commits format, is limited to 50 characters, and phrased in the imperative
     - Commit description consists of bullet points, also phrased in the imperative, and limited to 72 characters per line
3. Commit using `git commit -m "<summary>" -m "<description>" -e`.
