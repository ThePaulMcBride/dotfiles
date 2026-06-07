{ ... }:
{
  xdg.enable = true;

  catppuccin = {
    autoEnable = false;
    enable = true;
    flavor = "macchiato";
    k9s.enable = true;
  };

  programs.k9s.enable = true;
}
