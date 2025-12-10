_: { pkgs, ... }: {
  programs.lazygit = {
    settings = {
      gui = {
        scrollPastBottom = false;
        showBottomLine = false;
        nerdFontsVersion = 3;
        border = "rounded";
        showNumstatInFilesView = true;
        showBranchCommitHash = true;
        showDivergenceFromBaseBranch = "arrowAndNumber";
        statusPanelView = "allBranchesLog";
        switchTabsWithPanelJumpKeys = true;
        theme = {
          activeBorderColor = ["blue" "bold"];
          inactiveBorderColor = ["black"];
          searchingActiveBorderColor = ["cyan"];
          optionsTextColor = ["magenta"];
          selectedLineBgColor = ["reverse"];
          selectedRangeBgColor = ["reverse"];
          cherryPickedCommitBgColor = ["default"];
          cherryPickedCommitFgColor = ["yellow" "underline"];
          unstagedChangesColor = ["red"];
          defaultFgColor = ["default"];
        };
      };
      git = {
        log = {
          order = "date-order";
          showGraph = "always";
        };
        truncateCopiedCommitHashesTo = 40;
      };
      notARepository = "skip";
      promptToReturnFromSubprocess = false;
      quitOnTopLevelReturn = true;
      keybinding = {
        universal = {
          quit = "<disabled>";
        };
      };
      customCommands = [
        {
          key = "c";
          context = "files";
          command = "cd {{.SelectedWorktree.Path}} && meteor";
          output = "terminal";
          description = "Create new conventional commit";
          loadingText = "Creating conventional commit...";
        }
      ];
    };
  };
  home.packages = [pkgs.meteor-git];
}
