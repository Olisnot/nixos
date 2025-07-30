{ lib, config, ... }:

{
  options = {
    otd.kamvas13.enable = lib.mkEnableOption "Add file required to use Huion Kamvas 13";
  };

  config = lib.mkIf config.otd.kamvas13.enable {
    home.file."Kamvas 13.json" = {
      enable = true;
      target = ".local/share/OpenTabletDriver/Configurations/Huion/Kamvas 13.json";
      text = /* json */ ''
      {
        "Name": "Huion Kamvas 13",
        "Specifications": {
          "Digitizer": {
            "Width": 293.76,
            "Height": 165.24,
            "MaxX": 58752.0,
            "MaxY": 33048.0
          },
          "Pen": {
            "MaxPressure": 8191,
            "Buttons": {
              "ButtonCount": 2
            }
          },
          "AuxiliaryButtons": {
            "ButtonCount": 10
          },
          "MouseButtons": null,
          "Touch": null
        },
        "DigitizerIdentifiers": [
          {
            "VendorID": 9580,
            "ProductID": 109,
            "InputReportLength": 12,
            "OutputReportLength": null,
            "ReportParser": "OpenTabletDriver.Configurations.Parsers.UCLogic.UCLogicTiltReportParser",
            "FeatureInitReport": null,
            "OutputInitReport": null,
            "DeviceStrings": {
              "201": "HUION_(?:M20h|M19f|M215)_\\d{6}$"
            },
            "InitializationStrings": [
              200
            ],
            "Attributes": {}
          }
        ],
        "AuxilaryDeviceIdentifiers": [],
        "Attributes": {
          "libinputoverride": "1"
        }
      }
      '';
    };
  };
}
