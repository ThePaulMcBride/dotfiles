# Dotfiles

Nix flake-based system configuration managing three machines:

| Host | Type | Description |
|------|------|-------------|
| **carbon** | macOS (aarch64-darwin) | Personal Mac |
| **neon** | macOS (aarch64-darwin) | Work Mac |
| **argon** | NixOS (x86_64-linux) | Desktop |

## Prerequisites

1. Install [Nix](https://determinate.systems/nix-installer/) using the Determinate installer

Homebrew, 1Password, and all other dependencies are installed automatically during the first build.

## Fresh macOS Setup

1. Clone this repo via HTTPS (SSH isn't available yet on a fresh machine):

   ```sh
   git clone https://github.com/ThePaulMcBride/dotfiles.git ~/dotfiles
   ```

2. Run the initial build:

   ```sh
   nix run nix-darwin -- switch --flake ~/dotfiles#<hostname>
   ```

   For example, `~/dotfiles#carbon` for the personal Mac or `~/dotfiles#neon` for the work Mac.

3. Open 1Password, sign in, and enable the SSH agent (Settings > Developer > SSH Agent). The git config rewrites all GitHub HTTPS URLs to SSH and enables commit signing via `op-ssh-sign`, so 1Password must be configured before the next step.

4. Run the build again to ensure everything completes cleanly with SSH available:

   ```sh
   sudo darwin-rebuild switch --flake ~/dotfiles#<hostname>
   ```

5. Switch the repo remote to SSH:

   ```sh
   git -C ~/dotfiles remote set-url origin git@github.com:ThePaulMcBride/dotfiles.git
   ```

## Fresh NixOS Setup

```sh
sudo nixos-rebuild switch --flake ~/dotfiles#argon
```

## Day-to-Day Usage

After the initial setup, shell aliases are available:

```sh
darwin-switch        # Rebuild macOS config (auto-detects hostname)
darwin-switch-home   # Rebuild with carbon config
darwin-switch-work   # Rebuild with neon config
nix-switch           # Rebuild NixOS config
nix-update           # Update flake inputs
```

## Structure

```
dotfiles/          # Application configs (git, nvim, zsh, ghostty, etc.)
hosts/             # Per-machine host definitions
modules/           # Reusable Nix modules
scripts/           # Shell scripts installed via Home Manager
flake.nix          # Flake entry point
```
