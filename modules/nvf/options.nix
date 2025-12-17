_: {lib, ...}: {
  vim.options = {
    exrc = true; # load .nvimrc, .nvim.lua in workspace

    numberwidth = 2; # default size of line number column

    cursorline = true;
    cursorlineopt = "both"; # highlight line and line number

    linebreak = true; # Wrap long lines at 'breakat' (if 'wrap' is set)
    breakindent = true; # wrapped lines are indented below their parent
    sidescroll = 5;
    virtualedit = "block"; # allow moving the cursor even where there is no text, in v-block mode
    list = true;
    listchars = "trail:◦,multispace:◦,leadmultispace: ,nbsp:⍽,precedes:«,extends:»";

    fillchars = "eob: ,fold: ";

    foldlevel = 99;
    foldtext = "v:lua.vim.g.foldtext()"; # defined in config.vim.globals

    # Formatting
    # if opening a new line with <Enter>/o/O in a comment block, automatically add the comment leader
    # autoformat affects comments
    # autoformat indents multiline numbered list entries
    # do not automatically break lines on textwidth in insert mode
    # allow newlines at multibyte characters, and join them without adding spaces between
    # for one-letter words, break before rather than after them
    # remove comment leaders when joining lines
    formatoptions = "ro/qnlmB1j";

    expandtab = true;
    shiftwidth = 2;
    smartindent = true;
    tabstop = 2;
    softtabstop = 2;

    ignorecase = true;
    smartcase = true;
    incsearch = true;

    timeoutlen = 400;
    whichwrap = "<>[]bshl"; # go to previous/next line with h,l, back/space, left arrow and right arrow

    undofile = true;
    updatetime = 250; # interval for writing swap file to disk, also used by gitsigns
    writebackup = true; # when writing, create a backup...
    backupcopy = "auto"; # by renaming the original file (unless it has special attributes or is a link)...
    backup = false; # and don't keep the backup after the write succeeds
  };
  vim.globals.foldtext = lib.generators.mkLuaInline ''
    function()
      return vim.fn.getline(vim.v.foldstart)
        .. " ("
        .. (vim.v.foldend - vim.v.foldstart - 1)
        .. " lines folded) "
        .. vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
    end
  '';
}
