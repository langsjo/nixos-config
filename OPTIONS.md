## custom\.gaming\.enable

Whether to enable Enable gaming related programs and services\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gaming](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gaming)



## custom\.gui\.enable



Enable programs that require a GUI



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gui](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gui)



## custom\.gui\.displayManager\.ly\.enable



Whether to enable Enable the ly display manager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gui/ly\.nix](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gui/ly.nix)



## custom\.gui\.programs\.enable



Enable programs that require a GUI



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/programs/gui](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/programs/gui)



## custom\.gui\.windowManager\.dwm\.enable



Whether to enable Enable the dwm window manager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gui/dwm\.nix](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gui/dwm.nix)



## custom\.gui\.windowManager\.dwm\.status\.enable



Enable the dwm-status statusbar



*Type:*
boolean



*Default:*
` config.custom.gui.windowManager.dwm.enable `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gui/dwm-status\.nix](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gui/dwm-status.nix)



## custom\.gui\.xserver\.enable



Whether to enable Enable the X server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gui/xserver\.nix](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/gui/xserver.nix)



## custom\.hardware\.audio\.enable



Enable audio



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/hardware/audio\.nix](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/hardware/audio.nix)



## custom\.hardware\.bluetooth\.enable



Enable bluetooth



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/hardware/bluetooth\.nix](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/hardware/bluetooth.nix)



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
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/user](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/user)



## custom\.isLaptop



Whether to enable Is the host a laptop\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/common/options\.nix](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/common/options.nix)



## custom\.user\.homeDirectory



User’s home directory



*Type:*
string



*Default:*
` "/home/{config.custom.user.username}" `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/common/user\.nix](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/common/user.nix)



## custom\.user\.username



User’s username



*Type:*
string



*Default:*
` "langsjo" `

*Declared by:*
 - [/nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/common/user\.nix](file:///nix/store/4ngi52iqmszymy1vgdzpilyqrk00mgr5-source/modules/system/common/user.nix)


