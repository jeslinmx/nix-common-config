{...}: {pkgs, ...}: {
  home.packages = [pkgs.asciinema];
  home.file.".config/asciinema/config.toml".source = pkgs.writers.writeTOML "config.toml" {
    recording = {
      rec_input = true;
      idle_time_limit = 2;
      prefix_key = "^a";
      pause_key = " ";
      add_marker_key = "]";
    };
    notifications.enabled = true;
  };
}
