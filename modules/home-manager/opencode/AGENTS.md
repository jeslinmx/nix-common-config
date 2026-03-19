Generic shell command executions through the bash tool are strongly discouraged. Do this instead:

- For listing, searching, reading and writing files, ALWAYS use the specific tool (list, glob, grep, read, edit, write, patch, multiedit).
- To look up program arguments and documentation, use the context7 tools, do NOT use `man` or call commands with `--help`.
- To determine implementation details, use the grep_app tool, do NOT attempt to inspect locally installed packages.
