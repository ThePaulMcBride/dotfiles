# Dotfiles

Nix flake-based system configuration managing three machines:

| Host | Type | Description |
|------|------|-------------|
| **carbon** | macOS (aarch64-darwin) | Personal Mac |
| **neon** | macOS (aarch64-darwin) | Work Mac |
| **argon** | NixOS (x86_64-linux) | Desktop |

## Prerequisites

1. Install [Nix](https://nixos.org/download/)
2. Install [Homebrew](https://brew.sh/)
3. Install and configure [1Password](https://1password.com/) with SSH agent integration enabled (required for cloning this repo via SSH)

## Fresh macOS Setup

Clone this repo into the home directory:

```sh
git clone git@github.com:ThePaulMcBride/dotfiles.git ~/dotfiles
```

Run the initial build:

```sh
nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/dotfiles#<hostname>
```

For example, `~/dotfiles#carbon` for the personal Mac or `~/dotfiles#neon` for the work Mac.

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
