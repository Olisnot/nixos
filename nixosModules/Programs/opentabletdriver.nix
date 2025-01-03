{ lib, config, ... }:

{
  options = {
    opentabletdriverudev.enable = lib.mkEnableOption "Add udev rules for open tablet driver";
  };

  config = lib.mkIf config.opentabletdriverudev.enable {
        # Huion tablet drivers
        hardware.opentabletdriver.enable = true;
        services.udev.extraRules = "
        # Dynamically generated with the OpenTabletDriver.udev tool. https://github.com/OpenTabletDriver/OpenTabletDriver
        KERNEL==\"uinput\", SUBSYSTEM==\"misc\", TAG+=\"uaccess\", OPTIONS+=\"static_node=uinput\"
        # VEIKK A50 V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0003\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0003\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0003\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK A30 V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0002\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0002\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0002\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK S640
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0001\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0001\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0001\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK A15
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0004\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0004\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0004\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK A15 V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0004\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0004\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0004\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK S640 V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0001\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0001\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0001\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK VK1060
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0008\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0008\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0008\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK A30
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0002\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0002\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0002\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK A15 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0006\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0006\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0006\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK VK430
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0009\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0009\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0009\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK Viola (VO1060)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"000b\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"000b\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"000b\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK A50
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0003\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0003\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0003\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # VEIKK VK640
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0005\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0005\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2feb\", ATTRS{idProduct}==\"0005\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Wacom XD-0405-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0041\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0041\", MODE=\"0666\"
        # Wacom CTE-450
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0017\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0017\", MODE=\"0666\"
        # Wacom CTL-4100
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0374\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0374\", MODE=\"0666\"
        # Wacom CTL-680
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0323\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0323\", MODE=\"0666\"
        # Wacom PTZ-930
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b2\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b2\", MODE=\"0666\"
        # Wacom XD-0912-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0043\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0043\", MODE=\"0666\"
        # Wacom PTZ-1230
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b3\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b3\", MODE=\"0666\"
        # Wacom PTH-651
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0315\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0315\", MODE=\"0666\"
        # Wacom CTL-471
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0300\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0300\", MODE=\"0666\"
        # Wacom CTL-672
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"037b\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"037b\", MODE=\"0666\"
        # Wacom Cintiq 13HD (DTK-1300)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0304\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0304\", MODE=\"0666\"
        # Wacom PTZ-1231W
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b4\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b4\", MODE=\"0666\"
        # Wacom GD-1212-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0023\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0023\", MODE=\"0666\"
        # Wacom XD-1212-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0044\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0044\", MODE=\"0666\"
        # Wacom CTH-480
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0302\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0302\", MODE=\"0666\"
        # Wacom DTC-133
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"03a6\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"03a6\", MODE=\"0666\"
        # Wacom CTH-470
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00de\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00de\", MODE=\"0666\"
        # Wacom CTL-472
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"037a\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"037a\", MODE=\"0666\"
        # Wacom CTF-430
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0069\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0069\", MODE=\"0666\"
        # Wacom CTL-470
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00dd\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00dd\", MODE=\"0666\"
        # Wacom CTH-301
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0318\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0318\", MODE=\"0666\"
        # Wacom XD-1218-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0045\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0045\", MODE=\"0666\"
        # Wacom CTL-690
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"033d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"033d\", MODE=\"0666\"
        # Wacom PTK-650
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"002a\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"002a\", MODE=\"0666\"
        # Wacom XD-0608-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0042\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0042\", MODE=\"0666\"
        # Wacom CTL-6100
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0375\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0375\", MODE=\"0666\"
        # Wacom PTH-450
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0026\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0026\", MODE=\"0666\"
        # Wacom GD-1218-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0024\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0024\", MODE=\"0666\"
        # Wacom ET-0405-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0010\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0010\", MODE=\"0666\"
        # Wacom PTK-440
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b8\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b8\", MODE=\"0666\"
        # Wacom PTH-860
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0358\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0358\", MODE=\"0666\"
        # Wacom GD-0608-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0021\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0021\", MODE=\"0666\"
        # Wacom CTH-680
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0303\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0303\", MODE=\"0666\"
        # Wacom CTE-430
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0013\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0013\", MODE=\"0666\"
        # Wacom CTH-490
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"033c\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"033c\", MODE=\"0666\"
        # Wacom PTK-640
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b9\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b9\", MODE=\"0666\"
        # Wacom ET-0405A-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0011\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0011\", MODE=\"0666\"
        # Wacom CTE-660
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"006b\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"006b\", MODE=\"0666\"
        # Wacom FT-0405-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0060\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0060\", MODE=\"0666\"
        # Wacom PTH-850
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0028\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0028\", MODE=\"0666\"
        # Wacom Cintiq 16 (DTK1660)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0390\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"03ae\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0390\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"03ae\", MODE=\"0666\"
        # Wacom CTL-6100WL
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0378\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"03c7\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0378\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"03c7\", MODE=\"0666\"
        # Wacom CTH-661
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d3\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00db\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d8\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d3\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00db\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d8\", MODE=\"0666\"
        # Wacom PTZ-631W
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b5\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b5\", MODE=\"0666\"
        # Wacom CTE-630
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0014\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0014\", MODE=\"0666\"
        # Wacom CTE-640
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0016\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0016\", MODE=\"0666\"
        # Wacom PTH-650
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0027\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0027\", MODE=\"0666\"
        # Wacom PTH-660
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0357\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0360\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0357\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0360\", MODE=\"0666\"
        # Wacom PTK-540WL
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00bc\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00bc\", MODE=\"0666\"
        # Wacom GD-0912-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0022\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0022\", MODE=\"0666\"
        # Wacom PTK-450
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0029\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0029\", MODE=\"0666\"
        # Wacom CTL-490
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"033b\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"033b\", MODE=\"0666\"
        # Wacom CTE-440
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0015\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0015\", MODE=\"0666\"
        # Wacom CTL-460
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d4\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d4\", MODE=\"0666\"
        # Wacom Cintiq 12WX (DTZ-1200W)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00c6\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00c6\", MODE=\"0666\"
        # Wacom MTE-450
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0065\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0065\", MODE=\"0666\"
        # Wacom PTZ-630
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b1\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b1\", MODE=\"0666\"
        # Wacom CTL-480
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"030e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"030e\", MODE=\"0666\"
        # Wacom CTE-460
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"006a\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"006a\", MODE=\"0666\"
        # Wacom GD-0405-U
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0020\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0020\", MODE=\"0666\"
        # Wacom CTH-690
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"033e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"033e\", MODE=\"0666\"
        # Wacom PTK-840
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00ba\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00ba\", MODE=\"0666\"
        # Wacom CTL-4100WL
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0376\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0377\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"03c5\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0376\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0377\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"03c5\", MODE=\"0666\"
        # Wacom PTZ-430
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b0\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b0\", MODE=\"0666\"
        # Wacom PTZ-431W
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b7\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00b7\", MODE=\"0666\"
        # Wacom PTH-451
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0314\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0314\", MODE=\"0666\"
        # Wacom CTH-670
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00df\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00df\", MODE=\"0666\"
        # Wacom CTE-650
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0018\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0018\", MODE=\"0666\"
        # Wacom CTH-461
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d2\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d7\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00da\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d2\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d7\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00da\", MODE=\"0666\"
        # Wacom PTH-851
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0317\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0317\", MODE=\"0666\"
        # Wacom PTK-1240
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00bb\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00bb\", MODE=\"0666\"
        # Wacom PTH-460
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0392\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0392\", MODE=\"0666\"
        # Wacom CTH-460
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d6\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d1\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d6\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"00d1\", MODE=\"0666\"
        # Wacom CTL-671
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0301\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", ATTRS{idProduct}==\"0301\", MODE=\"0666\"
        # Acepen AP 1060
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0082\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0082\", MODE=\"0666\"
        # Parblo Ninos M
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a005\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a005\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a005\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Parblo A609
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0b57\", ATTRS{idProduct}==\"9091\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0b57\", ATTRS{idProduct}==\"9091\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"0b57\", ATTRS{idProduct}==\"9091\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Parblo A610 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"1903\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"1903\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"1903\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Parblo Intangbo S
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a014\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a014\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a014\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Parblo A640 V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a640\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a640\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a640\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Parblo Intangbo M
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a013\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a013\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a013\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Parblo Ninos S
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a006\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a006\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"a006\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XENX X1-640
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2d80\", ATTRS{idProduct}==\"6001\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2d80\", ATTRS{idProduct}==\"6001\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2d80\", ATTRS{idProduct}==\"6001\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XENX P1-640
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2d80\", ATTRS{idProduct}==\"2002\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2d80\", ATTRS{idProduct}==\"2002\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2d80\", ATTRS{idProduct}==\"2002\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XENX P3-1060
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"2d80\", ATTRS{idProduct}==\"2001\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"2d80\", ATTRS{idProduct}==\"2001\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"2d80\", ATTRS{idProduct}==\"2001\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # UC-Logic PF1209
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0042\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0042\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0042\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # UC-Logic 1060N
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0081\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0081\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0081\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Genius i405x
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0458\", ATTRS{idProduct}==\"5010\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0458\", ATTRS{idProduct}==\"5010\", MODE=\"0666\"
        # Genius G-Pen 560
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0458\", ATTRS{idProduct}==\"5003\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0458\", ATTRS{idProduct}==\"5003\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"0458\", ATTRS{idProduct}==\"5003\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Genius i608x
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0458\", ATTRS{idProduct}==\"501a\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0458\", ATTRS{idProduct}==\"501a\", MODE=\"0666\"
        # UGEE S640
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0937\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0937\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0937\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # UGEE U1600
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"093c\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"093c\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"093c\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # UGTABLET M708 V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0924\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0924\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0924\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # UGTABLET M708
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0081\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0081\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0081\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon PD1161
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon M6
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon PD2200
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon M10K Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon M1220
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon M10K
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon S830
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon S56K
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon GM156HD
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon M106K
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon S620
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006f\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006f\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006f\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon PD1560
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon S630
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon PD1561
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon M1230
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon M106K Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Gaomon 1060 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Artisul M0610 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0081\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0081\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0081\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Artisul AP604
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0054\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0054\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0054\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Artisul A1201
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # ViewSonic Woodpad PF0730
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0543\", ATTRS{idProduct}==\"e667\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0543\", ATTRS{idProduct}==\"e667\", MODE=\"0666\"
        # RobotPen T9A
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"6003\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"6003\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"6003\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XenceLabs Pen Tablet Medium
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"5201\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"5201\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"5201\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XenceLabs Pen Tablet Small
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"5204\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"5204\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"5204\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # LifeTec LT9570
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"08ca\", ATTRS{idProduct}==\"0010\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"08ca\", ATTRS{idProduct}==\"0010\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"08ca\", ATTRS{idProduct}==\"0010\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # FlooGoo FMA100
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"0a12\", ATTRS{idProduct}==\"4007\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0a12\", ATTRS{idProduct}==\"4007\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"0a12\", ATTRS{idProduct}==\"4007\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Monoprice 10594
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Monoprice MP1060-HA60
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0781\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0781\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0781\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion GT-220 V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas 22 Plus
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H610 Pro V3
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H420
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H610X
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion GT-221 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas Pro 16
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion HS95
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Q620M
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion RTM-500
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas Pro 20
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H320M
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006f\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006f\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006f\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas Pro 12
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion 420
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Q11K V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas 13
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H690
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas Pro 13 (2.5k)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas 16
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion GC610
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion WH1409
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas 16 (2021)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H642
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Q11K
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas Pro 24
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion HS64
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion New 1060 Plus (2048)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H640P
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H1060P
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H430P
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006f\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006f\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006f\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion G10T
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion New 1060 Plus
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas Pro 16 (2.5k)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        # Huion HC16
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H580X
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H610 Pro V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas 12
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion HS611
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion WH1409 V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas Pro 13
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H610 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H950P
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion Kamvas 20
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H1161
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion H420X
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0064\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion HS610
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"006d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # Huion G930L
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0061\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"256c\", ATTRS{idProduct}==\"0061\", MODE=\"0666\"
        # KENTING K5540
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0004\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0004\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0004\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Artist 13 (2nd Gen)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094e\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094e\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen CT1060
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0932\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0932\", MODE=\"0666\"
        # XP-Pen Star G540
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0075\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0075\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0075\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Deco 01 V2 (variant 2)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0905\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0905\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0905\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Artist 15.6 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"090d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"090d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"090d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star G540 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0061\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0061\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0061\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star G640 V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0914\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0914\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0914\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Artist 10 (2nd Gen)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094d\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094d\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094d\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Deco Pro Medium
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0904\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0904\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0904\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star 05 V3
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0071\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0071\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0071\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star G640
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0094\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0094\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0094\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Artist 15.6
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"000c\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"091a\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"000c\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"091a\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"000c\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"091a\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Deco mini4
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0929\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0929\", MODE=\"0666\"
        # XP-Pen Artist 12 (2nd Gen)
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094a\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094a\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094a\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen CT430
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0930\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0930\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0930\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Artist 22HD
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0047\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"5543\", ATTRS{idProduct}==\"0047\", MODE=\"0666\"
        # XP-Pen CT640
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0931\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0931\", MODE=\"0666\"
        # XP-Pen Artist 12
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"080a\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"080a\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"080a\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Deco mini7
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0928\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0928\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0928\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Artist Pro 16TP
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"092e\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"092e\", MODE=\"0666\"
        # XP-Pen Artist 12 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"091f\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"091f\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"091f\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Deco 02
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0803\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0803\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0803\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star G430
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0075\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0075\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0075\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star G960S Plus
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0918\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0918\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0918\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star 06
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0078\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0078\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0078\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star 06C
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0062\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0062\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0062\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Deco 01 V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0905\", MODE=\"0666\"
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0902\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0905\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0902\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0905\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0902\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Innovator 16
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"092c\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"092c\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"092c\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Deco Pro SW
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0933\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0933\", MODE=\"0666\"
        # XP-Pen Star G960S
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0917\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0917\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0917\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Artist 13.3
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"000b\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"000b\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"000b\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star G430S
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0075\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0075\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0075\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Deco 01
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0042\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0042\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0042\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star G960
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0920\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0920\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0920\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star G430S V2
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0913\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0913\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0913\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Artist 13.3 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"092b\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"092b\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"092b\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Deco Pro Small
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0909\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0909\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0909\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Deco 03
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0096\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0096\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0096\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Artist 16 Pro
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094b\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094b\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"094b\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star 03
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0907\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0907\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0907\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # XP-Pen Star G640S
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0906\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0906\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"28bd\", ATTRS{idProduct}==\"0906\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        # 10moon 1060N
        SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"08f2\", ATTRS{idProduct}==\"6811\", MODE=\"0666\"
        SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"08f2\", ATTRS{idProduct}==\"6811\", MODE=\"0666\"
        SUBSYSTEM==\"input\", ATTRS{idVendor}==\"08f2\", ATTRS{idProduct}==\"6811\", ENV{LIBINPUT_IGNORE_DEVICE}=\"1\"
        ";
      };
}
