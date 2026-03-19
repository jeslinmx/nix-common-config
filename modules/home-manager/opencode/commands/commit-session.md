---
description: Prepare a git commit based on the current session
---

Last 10 git commits:

```
!`git log --pretty="format:%s%n%b%n---%n" -10`
```

Git status:

```
!`git status`
```

Git index diff:

```
!`git diff --cached --no-ext-diff`
```

1. Summarize implemented changes from this session into a commit summary and description. Comply with the style of the prior commits provided above.
   - If no established convention exists, use Conventional Commits.
2. Inspect the git index diff.
   - If no files are staged, determine what changes were made in this session and offer to stage them.
   - If there are staged files but these are not consistent with the commit message, inform me and offer to stash the staged changes and stage the appropriate files.
3. Commit using `git commit -m "<summary>" -m "<description>" --edit`.

With the exception of the case where the staged changes are not consistent with the commit message, do not provide any informational messages or ask for approval, I will tweak and approve from the editor.
