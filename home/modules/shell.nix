{ lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initContent = lib.mkAfter ''
      # Enable colors in completion lists.
      zstyle ':completion:*' list-colors ""

      # Case-insensitive prefix and substring matching.
      zstyle ':completion:*' matcher-list \
        'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
        'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
    '';
  };
}
