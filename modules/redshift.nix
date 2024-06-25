{ pkgs, config, libs, ... }:

{
# location.provider = "geoclue2"
# All values except 'enable' are optional.
        services.redshift = {
            enable = true;
            brightness = {
# Note the string values below.
                day = "1";
                night = "1";
            };
            temperature = {
                day = 5500;
                night = 3700;
            };
        };
}
