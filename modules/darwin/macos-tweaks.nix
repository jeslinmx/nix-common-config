_: _: {
  system.defaults = {
    ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0; # disable mouse accel
    controlcenter = {
      AirDrop = false;
      BatteryShowPercentage = true;
      Bluetooth = true;
      Display = false;
      FocusModes = true;
      NowPlaying = false;
      Sound = true;
    };
    dock = {
      appswitcher-all-displays = true;
      autohide-time-modifier = 0.2;
      expose-animation-duration = 0.2;
      magnification = true; # on hover
      minimize-to-application = true;
      mru-spaces = false; # do not rearrange spaces by recent usage
      orientation = "right";
      scroll-to-open = true;
      showhidden = true; # hidden applications have translucent icons
      tilesize = 48; # icon size
      largesize = 64;
    };
    finder = {
      _FXEnableColumnAutoSizing = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      _FXSortFoldersFirstOnDesktop = true;
      AppleShowAllExtensions = true; # file extensions in Finder
      FXDefaultSearchScope = "SCcf"; # scope search to current folder by default
      FXPreferredViewStyle = "clmv"; # column view by default
      ShowMountedServersOnDesktop = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    hitoolbox.AppleFnUsageType = "Change Input Source"; # Fn key switches languages
    iCal = {
      "first day of week" = "Sunday";
      "TimeZone support enabled" = true;
      CalendarSidebarShown = true;
    };
    loginwindow = {
      DisableConsoleAccess = true;
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
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSStatusItemSelectionPadding = 4;
      NSStatusItemSpacing = 8;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      NSWindowShouldDragOnGesture = true;
      "com.apple.keyboard.fnState" = false; # Fn keys function as media keys
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.feedback" = 1;
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay" = 0.7; # spring directories open faster
      "com.apple.swipescrolldirection" = true; # natural scrolling
      "com.apple.trackpad.enableSecondaryClick" = true; # scroll with 2 fingers
      "com.apple.trackpad.forceClick" = true;
      AppleEnableSwipeNavigateWithScrolls = true;
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 2; # tab changes focus
      _HIHideMenuBar = false;
      AppleMeasurementUnits = "Centimeters";
      AppleTemperatureUnit = "Celsius";
      AppleMetricUnits = 1;
      AppleScrollerPagingBehavior = true; # click on scroll bar to scroll
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Automatic";
    };
    screencapture = {
      disable-shadow = true;
      location = "~/Pictures/Screenshots";
      show-thumbnail = true;
      target = "clipboard";
    };
    trackpad = {
      Clicking = true;
      Dragging = true; # double-tap to drag
      DragLock = true; # tap again to release
      FirstClickThreshold = 0; # less pressure for clicking
      SecondClickThreshold = 0; # less pressure for force-clicking
      TrackpadFourFingerPinchGesture = 2; # spread to show desktop, pinch for launchpad
      TrackpadPinch = true; # two finger pinch zoom
      TrackpadThreeFingerTapGesture = 0; # disable 3 finger tap for look up
      TrackpadTwoFingerDoubleTapGesture = true; # double-tap with 2 fingers for smart zoom
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3; # 2 finger right edge swipe for notification centre
      TrackpadRightClick = true;
    };
    WindowManager = {
      EnableStandardClickToShowDesktop = false; # only in stage manager
      EnableTiledWindowMargins = true;
      EnableTilingByEdgeDrag = true;
      EnableTilingOptionAccelerator = true; # alt+arrows to tile
      EnableTopTilingByEdgeDrag = true;
    };
  };
}
