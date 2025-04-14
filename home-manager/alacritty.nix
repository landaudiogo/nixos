{ pkgs, ... }:

{
    programs.alacritty = {
        enable = true;
        settings = {
            colors.primary = {
                background = "#1E1E1E";
                foreground = "#D8DEE9";
            };

            colors.normal = {
                black = "#3B4252";
                red = "#D54646";
                green = "#23D18B";
                yellow = "#D7BA7D";
                blue = "#569CD6";
                magenta = "#C586C0";
                cyan = "#29B8DB";
                white = "#abb2bf";
            };

            colors.bright = {
                black = "#3B4252";
                red = "#D54646";
                green = "#23D18B";
                yellow = "#D7BA7D";
                blue = "#569CD6";
                magenta = "#C586C0";
                cyan = "#29B8DB";
                white = "#ECEFF4";
            };

            shell = {
                program = "${pkgs.zsh}/bin/zsh";
                args = ["--login"];
            };

            font = {
              normal = {
                family = "CaskaydiaCove Nerd Font";
                style = "Regular";
              };

              bold = {
                family = "CaskaydiaCove Nerd Font";
                style = "Bold";
              };

              italic = {
                family = "CaskaydiaCove Nerd Font";
                style = "Italic";
              };

              bold_italic = {
                family = "CaskaydiaCove Nerd Font";
                style = "Bold Italic";
              };

              size = 7.5;
            };



            window = {
              padding = {
                x = 2;
                y = 2;
              };

              history = 20000;
              save_to_clipboard = true;
              live_config_reload = true;
            };

            key_bindings = [
              { key = "V"; mods = "Control|Shift"; action = "Paste"; }
              { key = "C"; mods = "Control|Shift"; action = "Copy"; }
              { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
              { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
            ];
        };
    };
}
