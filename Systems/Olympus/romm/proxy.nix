{ ... }:

{
  caddyReverseProxy.hosts."romm.opmsonline.org" = {
    upstream = "127.0.0.1:8082";
    readyFile = "/var/lib/caddy/public-ready/romm";
    waf = {
      mode = "DetectionOnly";
      # RomM 5.4.1 authenticates/authorizes chunk uploads before consuming the
      # binary stream, with a 64 MiB chunk cap. Do not buffer/parse these as
      # form data in Coraza. All other routes retain normal request inspection.
      beforeRules = ''
        SecRule REQUEST_METHOD "@streq PUT" "id:1100001,phase:1,pass,nolog,chain"
          SecRule REQUEST_FILENAME "@rx ^/api/roms/upload/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$" "ctl:requestBodyAccess=Off"
      '';
    };
    extraConfig = ''
      @romChunk {
        method PUT
        path_regexp romChunk ^/api/roms/upload/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$
      }
      request_body @romChunk {
        max_size 70MB
      }
    '';
  };
}
