let
  wrapCmd = command: commandArgs: args: opts:
    {
      inherit command;
      args =
        commandArgs
        ++ (
          if builtins.isList args
          then args
          else [args]
        );
    }
    // opts;
  wrapUrl = type: url: opts: {inherit url type;} // opts;
  uvx = wrapCmd "uvx" [];
  npx = wrapCmd "npx" ["-y"];
  streamable-http = wrapUrl "streamable-http";
  sse = wrapUrl "sse";
in {
  mcpServers = {
    context7 = streamable-http "https://mcp.context7.com/mcp" {autoApprove = true;};
    grep = streamable-http "https://mcp.grep.app" {autoApprove = true;};
    duckduckgo = uvx "duckduckgo-mcp-server" {
      autoApprove = true;
      disabled_tools = ["fetch_content"];
    };
    fetch = uvx "mcp-server-fetch" {autoApprove = true;};
    git = uvx ["mcp-server-git" "--repository" "\${workspaceFolder}"] {
      disabled = true;
      description = "Provides Git repository interaction and automation tools for reading, searching, and manipulating Git repositories through commands like status, diff, commit, branch management, and more.";
      autoApprove = ["git_branch" "git_diff" "git_diff_staged" "git_diff_unstaged" "git_log" "git_show" "git_status"];
    };
    memory = npx "@modelcontextprotocol/server-memory" {
      disabled = true;
      description = "A persistent memory system using a local knowledge graph that enables AI assistants to remember information about users across conversations through entities, relations, and observations.";
      autoApprove = true;
    };
    sequentialthinking = npx "@modelcontextprotocol/server-sequential-thinking" {
      disabled = true;
      description = "A structured problem-solving tool that enables step-by-step analysis, thought revision, and branching logic for complex reasoning tasks.";
      autoApprove = true;
    };
  };
  nativeMCPServers = {
    mcphub = {
      autoApprove = ["get_current_servers"];
    };
    neovim = {
      disabled_prompts = ["parrot"];
      disabled_tools = ["delete_items" "execute_lua"];
    };
  };
}
