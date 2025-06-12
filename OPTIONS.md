# NOTE: This file does not contains documentation of Home manager options
## custom\.gaming\.enable

Whether to enable Enable gaming related programs and services\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [./modules/system/gaming/default.nix](./modules/system/gaming/default.nix)



## custom\.gui\.enable



Enable programs that require a GUI



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [./modules/system/gui/default.nix](./modules/system/gui/default.nix)



## custom\.gui\.displayManager\.ly\.enable



Whether to enable Enable the ly display manager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [./modules/system/gui/ly\.nix](./modules/system/gui/ly.nix)



## custom\.gui\.programs\.enable



Enable programs that require a GUI



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [./modules/system/programs/gui/default.nix](./modules/system/programs/gui/default.nix)



## custom\.gui\.windowManager\.dwm\.enable



Whether to enable Enable the dwm window manager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [./modules/system/gui/dwm\.nix](./modules/system/gui/dwm.nix)



## custom\.gui\.windowManager\.dwm\.status\.enable



Enable the dwm-status statusbar



*Type:*
boolean



*Default:*
` config.custom.gui.windowManager.dwm.enable `

*Declared by:*
 - [./modules/system/gui/dwm-status\.nix](./modules/system/gui/dwm-status.nix)



## custom\.gui\.xserver\.enable



Whether to enable Enable the X server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [./modules/system/gui/xserver\.nix](./modules/system/gui/xserver.nix)



## custom\.hardware\.audio\.enable



Enable audio



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [./modules/system/hardware/audio\.nix](./modules/system/hardware/audio.nix)



## custom\.hardware\.bluetooth\.enable



Enable bluetooth



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [./modules/system/hardware/bluetooth\.nix](./modules/system/hardware/bluetooth.nix)



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
}
```



*Example:*

```
{
  enable = true;
  stateVersion = "25.05";
}
```

*Declared by:*
 - [./modules/user/default.nix](./modules/user/default.nix)



## custom\.isLaptop



Whether to enable Is the host a laptop\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [./modules/system/common/options\.nix](./modules/system/common/options.nix)



## custom\.user\.homeDirectory



User’s home directory



*Type:*
string



*Default:*
` "/home/{config.custom.user.username}" `

*Declared by:*
 - [./modules/system/common/user\.nix](./modules/system/common/user.nix)



## custom\.user\.username



User’s username



*Type:*
string



*Default:*
` "langsjo" `

*Declared by:*
 - [./modules/system/common/user\.nix](./modules/system/common/user.nix)


