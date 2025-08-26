_: {
  lib,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    settings.default_session.command = "${lib.getExe pkgs.tuigreet} ${builtins.concatStringsSep " " [
      "--time --time-format '%Y/%m/%d (%a) %H:%M:%S'" # display current time
      "--user-menu" # display menu of users
      "--asterisks" # show feedback when entering password
      "--window-padding=2" # add some padding to the border of the screen
      "--remember --remember-user-session" # remember last selected user and their selected session
    ]}";
  };
  console = {
    packages = [pkgs.cozette];
    font = "${pkgs.cozette}/share/consolefonts/cozette6x13.psfu";
  };
}
