final: prev: 
let 
    pkgs = prev;
    lib = prev.lib;
    nv-codecSrc = pkgs.fetchgit {
        url = "https://github.com/ffmpeg/nv-codec-headers";
        rev = "n11.1.5.3";
        hash = "sha256-5bz5B8r1dgz9cguY0UgisQmZRrDCp6MwGYlXNObAM14=";
    };
    nv-codec = pkgs.stdenvNoCC.mkDerivation {
        pname = "nv-codec-headers";
        version = "11.1.5.3";
        src = nv-codecSrc;
        makeFlags = [
            "PREFIX=$(out)"
        ];
    };
in
{
    ffmpeg_7-full = prev.ffmpeg_7-full.overrideAttrs (finalAttrs: prevAttrs: {
        buildInputs = (
            builtins.filter 
            (elem: !(lib.strings.hasInfix "nv-codec" elem.name))
            prevAttrs.buildInputs
        ) ++ [
            nv-codec
            prev.fdk_aac
        ];
        configureFlags = prevAttrs.configureFlags ++ [ "--enable-libfdk-aac" ];
    });
}
