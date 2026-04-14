{...}: _: {
  hardware.apple.touchBar = {
    enable = true;
    settings = {
      # https://github.com/AsahiLinux/tiny-dfr/blob/master/share/tiny-dfr/config.toml
      MediaLayerDefault = true;
      ShowButtonOutlines = true;
      EnablePixelShift = false;
      FontTemplate = "";
      AdaptiveBrightness = true;
      ActiveBrightness = 255;
      PrimaryLayerKeys = [
        {
          Text = "F1";
          Action = "F1";
          Stretch = 3;
        }
        {
          Text = "F2";
          Action = "F2";
          Stretch = 3;
        }
        {
          Text = "F3";
          Action = "F3";
          Stretch = 3;
        }
        {
          Text = "F4";
          Action = "F4";
          Stretch = 3;
        }
        {Stretch = 1;}
        {
          Text = "F5";
          Action = "F5";
          Stretch = 3;
        }
        {
          Text = "F6";
          Action = "F6";
          Stretch = 3;
        }
        {
          Text = "F7";
          Action = "F7";
          Stretch = 3;
        }
        {
          Text = "F8";
          Action = "F8";
          Stretch = 3;
        }
        {Stretch = 1;}
        {
          Text = "F9";
          Action = "F9";
          Stretch = 3;
        }
        {
          Text = "F10";
          Action = "F10";
          Stretch = 3;
        }
        {
          Text = "F11";
          Action = "F11";
          Stretch = 3;
        }
        {
          Text = "F12";
          Action = "F12";
          Stretch = 3;
        }
        {Stretch = 1;}
        {
          Text = "PrtSc";
          Action = "Sysrq";
          Stretch = 3;
        }
      ];
      MediaLayerKeys = [
        {
          Time = "%e/%m %H:%M";
          Action = "Time";
          Stretch = 4;
        }
        {
          Battery = "both";
          Action = "Battery";
          Stretch = 3;
        }
        {
          Icon = "brightness_low";
          Action = "BrightnessDown";
          Stretch = 2;
        }
        {
          Icon = "brightness_high";
          Action = "BrightnessUp";
          Stretch = 2;
        }

        {Stretch = 1;}
        {
          Icon = "fast_rewind";
          Action = "PreviousSong";
          Stretch = 2;
        }
        {
          Icon = "play_pause";
          Action = "PlayPause";
          Stretch = 3;
        }
        {
          Icon = "fast_forward";
          Action = "NextSong";
          Stretch = 2;
        }
        {Stretch = 1;}
        {
          Icon = "mic_off";
          Action = "MicMute";
          Stretch = 2;
        }
        {
          Icon = "volume_off";
          Action = "Mute";
          Stretch = 3;
        }
        {
          Icon = "volume_down";
          Action = "VolumeDown";
          Stretch = 3;
        }
        {
          Icon = "volume_up";
          Action = "VolumeUp";
          Stretch = 3;
        }
      ];
    };
  };
}
