{ lib, config, ... }:

{
  options = {
    ollama.enable = lib.mkEnableOption "Enable ollama for local LLM's";
  };

  config = lib.mkIf config.ollama.enable {
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };
  };
}
