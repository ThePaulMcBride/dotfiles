{ config, username, ... }:
let
  dotfilesDir = ../../dotfiles;
  repoDotfilesDir = "${config.home.homeDirectory}/dotfiles/dotfiles";

  sourceFile = rel: dotfilesDir + "/${rel}";
  repoLink = rel: config.lib.file.mkOutOfStoreSymlink "${repoDotfilesDir}/${rel}";
in
{
  home.username = username;
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.file = {
    ".claude/settings.json".source = sourceFile "claude/settings.json";
    ".config/alacritty".source = sourceFile "alacritty";
    ".config/git".source = sourceFile "git";
    ".config/jj".source = repoLink "jj";
    ".config/nix-darwin".source = repoLink "nix-darwin";
    ".config/nvim".source = repoLink "nvim";
    ".config/starship.toml".source = sourceFile "starship/starship.toml";
    ".config/zellij".source = sourceFile "zellij";
    ".zshenv".source = sourceFile "zsh/.zshenv";
    ".config/zsh/.zshrc".source = sourceFile "zsh/.zshrc";
    ".config/zsh/path".source = sourceFile "zsh/path";
    ".config/helix".source = sourceFile "helix";
    ".config/opencode/opencode.json".source = sourceFile "opencode/opencode.json";
    ".config/opencode/agents".source = repoLink "opencode/agents";
    ".config/opencode/skills".source = repoLink "opencode/skills";
    ".config/opencode/rules".source = repoLink "opencode/rules";
    ".pi/agent/settings.json".source = sourceFile "pi/agent/settings.json";
    ".pi/agent/extensions".source = repoLink "pi/agent/extensions";
    ".agents/skills".source = repoLink "agents/skills";
  };
}
