{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.custom.isLaptop {
    services = {
      upower.enable = true;
      tlp = {
        enable = true;
        # settings = {
        #   CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        #   CPU_BOOST_ON_BAT = true;
        #   CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
        #   PLATFORM_PROFILE_ON_BAT = "balanced";
        #   PCIE_ASPM_ON_BAT = "powersupersave";
        #   RUNTIME_PM_ON_BAT = "auto";
        #   SATA_LINKPWR_ON_BAT = "min-power";
        #   WIFI_PWR_ON_BAT = "on";
        #   SOUND_POWER_SAVE_ON_BAT = true;
        #   SOUND_POWER_SAVE_CONTROLLER = "Y";
        #   RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
        # };
      };
    };
  };
}
