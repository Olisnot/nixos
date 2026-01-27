{ ... }:

{
  programs.zed-editor.userSettings = {
    assistant = {
      enabled = true;
      version = "2";
      default_open_ai_model = null;
      default_model = {
        provider = "openai";
        model = "gpt-5-mini";
      };
    };
    features = { edit_prediction_provider = "supermaven"; };
  };
}
