extension Icon on Device {
  String getIconPath() {
    switch (deviceType) {
      case DeviceType.mobile:
        return AppIcon.platformMobile;
      case DeviceType.pc:
        return AppIcon.platformPc;
      case DeviceType.tablet:
        return AppIcon.platformTablet;
      case DeviceType.unknown:
        return AppIcon.device;
    }
  }
}
