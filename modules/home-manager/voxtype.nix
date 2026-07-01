_: {pkgs, ...}: {
  services.voxtype = {
    enable = true;
    package = pkgs.voxtype-vulkan;
    loadModels = ["base.en"];
    settings = {
      hotkey.enabled = false;
      output = {
        notification = {
          on_recording_start = true;
          on_recording_stop = true;
          on_transcription = false;
        };
        pre_type_delay_ms = 100;
        shift_enter_newlines = true;
      };
    };
  };
}
