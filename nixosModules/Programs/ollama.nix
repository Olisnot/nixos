{ pkgs, lib, config, ... }:

{
  options = {
    ollama.enable = lib.mkEnableOption "Enable ollama for local LLM's";
  };
  config = lib.mkIf config.ollama.enable {
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };
    services.open-webui = {
      package = pkgs.stable.open-webui;
      enable = true;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      };
    };
    environment.systemPackages = with pkgs; [
      oterm
      open-webui
    ];
  };
}
