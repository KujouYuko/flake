{ ... }:

{
  programs.git = {
    enable = true;
    package = null; # Git is already provided system-wide by environment.systemPackages.

    lfs = {
      enable = true;
      package = null; # Git LFS is already provided system-wide by environment.systemPackages.
    };

    settings = {
      diff.algorithm = "histogram";
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      pull.rebase = true;
      rebase.autoStash = true;
      rerere.enabled = true;

      core = {
        autocrlf = "input";
        editor = "vim";
      };

      fetch = {
        prune = true;
        pruneTags = true;
      };

      user = {
        name = "Kujou Yuko";
        email = "779@zako.club";
      };
    };
  };
}
