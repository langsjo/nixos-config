{
  lib,
  niri,
  fuzzel,
  swaylock,
  firefox,
  kitty-wrapped,
  brightnessctl,
  wireplumber,
  xwayland-satellite,
}:
let
  wpctl = lib.getExe' wireplumber "wpctl";
  bctl = lib.getExe brightnessctl;
in
{
  package = niri;
  includeBins = [ "niri" ];
  env.paths."NIRI_CONFIG"."/".text = /* kdl */ ''
    input {
        disable-power-key-handling
        focus-follows-mouse max-scroll-amount="1%"

        keyboard {
            xkb {
                layout "fi"
                variant "nodeadkeys"
            }
            repeat-delay 200
            repeat-rate 30
        }

        touchpad {
            dwt
            dwtp
            accel-profile "flat"
            click-method "clickfinger"
            scroll-method "two-finger"
        }

        mouse {
            accel-profile "flat"
        }

        trackpoint {
            accel-profile "flat"
            scroll-method "on-button-down"
            scroll-button 274
            accel-speed 0.1
            // middle-emulation
        }
    }

    output "eDP-1" {
        scale 1
        position x=0 y=0
        variable-refresh-rate
    }

    cursor {
        xcursor-theme "Vanilla-DMZ"
        hide-after-inactive-ms 9999999
    }

    layout {
        // Set gaps around windows in logical pixels.
        gaps 12

        // When to center a column when changing focus, options are:
        // - "never", default behavior, focusing an off-screen column will keep at the left
        //   or right edge of the screen.
        // - "always", the focused column will always be centered.
        // - "on-overflow", focusing a column will center it if it doesn't fit
        //   together with the previously focused column.
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
        }

        focus-ring {
            width 2

            active-color "#7fc8ff"

            inactive-color "#505050"
        }

        border {
            off
        }

        shadow {
            on
            softness 30
            spread 5
            offset x=0 y=5
            color "#0007"
        }

        tab-indicator {
            inactive-color "#4f689f"
        }

        // Struts shrink the area occupied by windows, similarly to layer-shell panels.
        // You can think of them as a kind of outer gaps. They are set in logical pixels.
        // Left and right struts will cause the next window to the side to always be visible.
        // Top and bottom struts will simply add outer gaps in addition to the area occupied by
        // layer-shell panels and regular gaps.
        struts {
            // left 64
            // right 64
            // top 64
            // bottom 64
        }
    }


    hotkey-overlay {
        skip-at-startup
    }

    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/%Y-%m%dT%H:%M:%S.png"

    animations {
        slowdown 0.8
    }

    xwayland-satellite {
        path "${lib.getExe xwayland-satellite}"
    }

    // Open the Firefox picture-in-picture player as floating by default.
    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        open-floating true
    }

    binds {
        // Suggested binds for running programs: terminal, app launcher, screen locker.
        Mod+Return { spawn "${lib.getExe kitty-wrapped}"; }
        Mod+W { spawn "${lib.getExe firefox}"; }
        Mod+D { spawn "${lib.getExe fuzzel}"; }
        Mod+P  { spawn "${lib.getExe swaylock}"; }

        XF86AudioRaiseVolume  allow-when-locked=true { spawn "${wpctl}" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+" "--limit" "1.0"; }
        XF86AudioLowerVolume  allow-when-locked=true { spawn "${wpctl}" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" "--limit" "1.0"; }
        XF86AudioMute         allow-when-locked=true { spawn "${wpctl}" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioMicMute      allow-when-locked=true { spawn "${wpctl}" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

        XF86MonBrightnessUp   allow-when-locked=true { spawn "${bctl}" "--class=backlight" "set" "+4%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "${bctl}" "--class=backlight" "set" "4%-"; }

        Mod+U repeat=false     { toggle-overview; }

        Mod+Q repeat=false     { close-window; }

        Mod+H       { focus-column-left; }
        Mod+J       { focus-window-or-workspace-down; }
        Mod+K       { focus-window-or-workspace-up; }
        Mod+L       { focus-column-right; }
        Mod+Tab     { focus-workspace-previous; }

        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down-or-to-workspace-down; }
        Mod+Shift+K     { move-window-up-or-to-workspace-up; }
        Mod+Shift+L     { move-column-right; }

        Mod+Ctrl+H     { focus-monitor-left; }
        Mod+Ctrl+J     { focus-monitor-down; }
        Mod+Ctrl+K     { focus-monitor-up; }
        Mod+Ctrl+L     { focus-monitor-right; }

        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        Mod+Ctrl+N   { move-workspace-down; }
        Mod+Ctrl+P   { move-workspace-up; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        Mod+Comma  { consume-or-expel-window-left; }
        Mod+Period { consume-or-expel-window-right; }

        Mod+S { switch-preset-column-width; }

        Mod+O { set-column-width "+5%"; }
        Mod+I { set-column-width "-5%"; }
        Mod+Shift+O { set-window-height "+5%"; }
        Mod+Shift+I { set-window-height "-5%"; }

        Mod+C { center-column; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Ctrl+F { expand-column-to-available-width; }

        Mod+Shift+Space { toggle-window-floating; }

        Mod+T { toggle-column-tabbed-display; }

        Mod+Shift+S { screenshot; }
        Print { screenshot-screen; }
        Mod+Print { screenshot-window; }

        // Applications such as remote-desktop clients and software KVM switches may
        // request that niri stops processing the keyboard shortcuts defined here
        // so they may, for example, forward the key presses as-is to a remote machine.
        // It's a good idea to bind an escape hatch to toggle the inhibitor,
        // so a buggy application can't hold your session hostage.
        //
        // The allow-inhibiting=false property can be applied to other binds as well,
        // which ensures niri always processes them, even when an inhibitor is active.
        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
    }
  '';
}
