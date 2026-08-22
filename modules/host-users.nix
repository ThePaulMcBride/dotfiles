{ user, ... }:

{
  users.users."${user.name}" = {
    home = user.homeDirectory;
    description = user.fullName;
  };

  nix.settings.trusted-users = [ user.name ];
}
