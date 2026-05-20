{ config, pkgs, lib, ... }:

let
  nvidiaVersion = "595.58.03";

  nvidiaLibs = pkgs.stdenv.mkDerivation {
    pname = "nvidia-gl-libs";
    version = nvidiaVersion;
    src = pkgs.fetchurl {
      url = "https://download.nvidia.com/XFree86/Linux-x86_64/${nvidiaVersion}/NVIDIA-Linux-x86_64-${nvidiaVersion}.run";
      sha256 = "1y99b0h3cv8panjsz4icf052nf83h7p2l9qlaymw8ckrgfb4y3cc";
    };
    nativeBuildInputs = [ pkgs.zstd ];
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/lib $out/share/glvnd/egl_vendor.d
      sh $src --extract-only --target nvidia
      cd nvidia

      for lib in libEGL_nvidia libGLX_nvidia libnvidia-glcore libnvidia-eglcore libnvidia-glsi; do
        cp ''${lib}.so.${nvidiaVersion} $out/lib/ 2>/dev/null || true
      done

      ln -sf libEGL_nvidia.so.${nvidiaVersion} $out/lib/libEGL_nvidia.so.0
      ln -sf libGLX_nvidia.so.${nvidiaVersion} $out/lib/libGLX_nvidia.so.0

      cp 10_nvidia.json $out/share/glvnd/egl_vendor.d/
    '';
  };

  eglPlatformDir = "/home/oyatomo/.local/lib/nvidia-egl-platforms";

  eglPlatformLibs = [
    "libnvidia-egl-xcb.so.1"
    "libnvidia-egl-xlib.so.1"
    "libnvidia-egl-gbm.so.1"
    "libnvidia-egl-wayland.so.1"
    "libnvidia-egl-wayland2.so.1"
  ];

  wezterm-with-gl = pkgs.symlinkJoin {
    name = "wezterm";
    paths = [ pkgs.wezterm ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for bin in wezterm wezterm-gui; do
        rm $out/bin/$bin
        makeWrapper ${pkgs.wezterm}/bin/$bin $out/bin/$bin \
          --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.libglvnd nvidiaLibs pkgs.mesa ]}:${eglPlatformDir}" \
          --set __EGL_VENDOR_LIBRARY_FILENAMES "${nvidiaLibs}/share/glvnd/egl_vendor.d/10_nvidia.json:${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json"
      done
    '';
  };
in
{
  programs.wezterm = {
    enable = true;
    package = wezterm-with-gl;
  };

  xdg.configFile."wezterm".source = ./../../../../wezterm;

  home.activation.setupNvidiaEglPlatforms = lib.hm.dag.entryAfter ["writeBoundary"] ''
    EGL_DIR="${eglPlatformDir}"
    mkdir -p "$EGL_DIR"

    # Clean up old transitive deps from previous versions
    find "$EGL_DIR" -maxdepth 1 -type f -name '*.so*' ! -name 'libnvidia-egl-*' -delete

    for lib in ${lib.concatStringsSep " " eglPlatformLibs}; do
      src="/usr/lib/x86_64-linux-gnu/$lib"
      if [ -f "$src" ] || [ -L "$src" ]; then
        cp -Lf "$src" "$EGL_DIR/$lib"
      fi
    done
  '';
}
