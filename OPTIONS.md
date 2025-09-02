# NOTE: This file does not contains documentation of Home manager options
## custom\.dev\.cursor\.enable

Whether to enable Enable the Cursor IDE\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/system/programs/gui/cursor\.nix](/modules/system/programs/gui/cursor.nix)



## custom\.gaming\.enable



Whether to enable Enable gaming related programs and services\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/system/gaming/default\.nix](/modules/system/gaming/default.nix)



## custom\.gaming\.osrs\.enable



Enable OSRS related configuration, such as Bolt launcher



*Type:*
boolean



*Default:*
` config.custom.gaming.enable `

*Declared by:*
 - [/modules/system/gaming/osrs\.nix](/modules/system/gaming/osrs.nix)



## custom\.gui\.enable



Enable programs that require a GUI



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/modules/system/gui/default\.nix](/modules/system/gui/default.nix)



## custom\.gui\.desktopManager\.plasma6\.enable



Whether to enable Enable the Plasma 6 desktop environment\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/system/gui/plasma6\.nix](/modules/system/gui/plasma6.nix)



## custom\.gui\.displayManager\.ly\.enable



Whether to enable Enable the ly display manager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/system/gui/ly\.nix](/modules/system/gui/ly.nix)



## custom\.gui\.programs\.enable



Enable programs that require a GUI



*Type:*
boolean



*Default:*
` config.custom.gui.enable `

*Declared by:*
 - [/modules/system/programs/gui/default\.nix](/modules/system/programs/gui/default.nix)



## custom\.gui\.windowManager\.dwm\.enable



Whether to enable Enable the dwm window manager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/system/gui/dwm\.nix](/modules/system/gui/dwm.nix)



## custom\.gui\.windowManager\.dwm\.status\.enable



Enable the dwm-status statusbar



*Type:*
boolean



*Default:*
` config.custom.gui.windowManager.dwm.enable `

*Declared by:*
 - [/modules/system/gui/dwm-status\.nix](/modules/system/gui/dwm-status.nix)



## custom\.gui\.xserver\.enable



Whether to enable Enable the X server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/system/gui/xserver\.nix](/modules/system/gui/xserver.nix)



## custom\.hardware\.audio\.enable



Enable audio



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/modules/system/hardware/audio\.nix](/modules/system/hardware/audio.nix)



## custom\.hardware\.bluetooth\.enable



Enable bluetooth



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/modules/system/hardware/bluetooth\.nix](/modules/system/hardware/bluetooth.nix)



## custom\.hardware\.gpuType



What type of GPU the host has



*Type:*
null or one of “nvidia”, “amd”, “intel”



*Default:*
` "nvidia" if nvidia drivers enabled, null otherwise `



*Example:*
` "nvidia" `

*Declared by:*
 - [/modules/system/hardware/default\.nix](/modules/system/hardware/default.nix)



## custom\.hardware\.graphics\.enable



Whether to enable hardware accelerated graphis drivers



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/modules/system/hardware/graphics\.nix](/modules/system/hardware/graphics.nix)



## custom\.home-manager



Attribute set to be passed to Home manager modules as custom config\.
Read custom options defined by Home manager modules to see possible options\.

The ` enable ` attribute defines whether Home manager is enabled at all\.



*Type:*
attribute set of anything



*Default:*

```
{
  enable = true;
  stateVersion = "{config.system.stateVersion}";
}
```

*Declared by:*
 - [/modules/user/default\.nix](/modules/user/default.nix)



## custom\.isLaptop



Whether to enable Is the host a laptop\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/system/common/options\.nix](/modules/system/common/options.nix)



## custom\.screen\.dpi



The dpi of the screen



*Type:*
signed integer



*Default:*
` 96 `

*Declared by:*
 - [/modules/system/common/options\.nix](/modules/system/common/options.nix)



## custom\.user\.homeDirectory



User’s home directory



*Type:*
string



*Default:*
` "/home/{config.custom.user.username}" `

*Declared by:*
 - [/modules/system/common/user\.nix](/modules/system/common/user.nix)



## custom\.user\.username



User’s username



*Type:*
string



*Default:*
` "langsjo" `

*Declared by:*
 - [/modules/system/common/user\.nix](/modules/system/common/user.nix)


