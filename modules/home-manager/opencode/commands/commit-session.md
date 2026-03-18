---
description: Prepare a git commit based on the current session
---
1. Summarize implemented changes from this session into a commit summary and description.
	- Comply with project-specific commit style conventions (in agent instructions, readmes, or precedent set by prior commits)
	- If no established convention exists, follow standard good practices:
		- Commit summary follows Conventional Commits format, is limited to 50 characters, and phrased in the imperative
		- Commit description consists of bullet points, also phrased in the imperative, and limited to 72 characters per line
2. Inspect the current state of the git index.
	- If no files are staged, determine what changes were made in this session and offer to stage them.
	- If there are staged files but these are not consistent with the commit message, inform the user and abort.
3. Commit using `git commit -m "<summary>" -m "<description>" -e`
