{...}: {...}: {
  system.defaults = {
    controlcenter = {
      AirDrop = false;
      BatteryShowPercentage = true;
      Bluetooth = true;
      Display = false;
      FocusModes = true;
      NowPlaying = true;
      Sound = true;
    };
    dock = {
      autohide = true;
      autohide-time-modifier = 0.7;
      expose-animation-duration = 0.7;
      magnification = true; # on hover
      minimize-to-application = true;
      mru-spaces = false; # do not rearrange spaces by recent usage
      scroll-to-open = true;
      showhidden = true; # hidden applications have translucent icons
      slow-motion-allowed = true; # hold shify key while minimizing
    };
    finder = {
      _FXSortFoldersFirst = true;
      _FXSortFoldersFirstOnDesktop = true;
      AppleShowAllExtensions = true; # file extensions in Finder
      FXDefaultSearchScope = "SCcf"; # scope search to current folder by default
      FXPreferredViewStyle = "clmv"; # column view by default
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    hitoolbox.AppleFnUsageType = "Change Input Source"; # Fn key switches languages
    iCal.CalendarSidebarShown = true;
    universalaccess.closeViewScrollWheelToggle = true; # ctrl+scroll to zoom
    loginwindow = {
      GuestEnabled = false;
      PowerOffDisabledWhileLoggedIn = true;
      RestartDisabledWhileLoggedIn = true;
      ShutDownDisabledWhileLoggedIn = true;
    };
    menuExtraClock = {
      FlashDateSeparators = true;
      Show24Hour = true;
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowSeconds = true;
    };
    NSGlobalDomain = {
      NSWindowShouldDragOnGesture = true;
      "com.apple.keyboard.fnState" = false; # Fn keys function as media keys
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay" = 0.7; # spring directories open faster
      "com.apple.swipescrolldirection" = true; # natural scrolling
      "com.apple.trackpad.enableSecondaryClick" = true; # scroll with 2 fingers
      "com.apple.trackpad.forceClick" = true;
      AppleEnableSwipeNavigateWithScrolls = true;
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3; # tab changes focus
      _HIHideMenuBar = false;
      AppleMeasurementUnits = "Centimeters";
      AppleTemperatureUnit = "Celsius";
      AppleMetricUnits = 1;
      AppleScrollerPagingBehavior = true; # click on scroll bar to scroll
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Automatic";
    };
    screencapture = {
      location = "~/Pictures/Screenshots";
      show-thumbnail = true;
    };
    trackpad = {
      Clicking = true;
      Dragging = true;
      FirstClickThreshold = 0; # less pressure for clicking
      SecondClickThreshold = 0; # less pressure for force-clicking
      TrackpadThreeFingerDrag = false;
      TrackpadRightClick = true;
    };
    WindowManager = {
      EnableStandardClickToShowDesktop = false; # only in stage manager
      EnableTiledWindowMargins = true;
      EnableTilingByEdgeDrag = true;
      EnableTilingOptionAccelerator = true; # alt+arrows to tile
      EnableTopTilingByEdgeDrag = true;
    };
    CustomUserPreferences = {
      NSGlobalDomain = {
        NSToolbarTitleViewRolloverDelay = 0; # instantly show the folder icon on toolbar hover
      };
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 1.0;
        "com.apple.mouse.linear" = 1; # disable mouse accel
      };
    };
  };
}
