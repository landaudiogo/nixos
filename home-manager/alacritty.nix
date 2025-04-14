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

            terminal.shell = {
                program = "${pkgs.tmux}/bin/tmux";
            };

            font = {
              normal = {
                family = "FiraCode Nerd Font";
                style = "Regular";
              };

              bold = {
                family = "FiraCode Nerd Font";
                style = "Bold";
              };

              italic = {
                family = "FiraCode Nerd Font";
                style = "Italic";
              };

              bold_italic = {
                family = "FiraCode Nerd Font";
                style = "Bold Italic";
              };

              size = 10;
            };



            window = {
              padding = {
                x = 2;
                y = 2;
              };
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
