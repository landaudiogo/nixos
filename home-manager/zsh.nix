{ pkgs, ... }:
{
    programs.zsh = {
        enable = true;
        autocd = true;
        plugins = [
            {
                name = "powerlevel10k";
                src = pkgs.zsh-powerlevel10k;
                file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
            {
                name = "p10k-config";
                src = ./p10k-config;
                file = "p10k.sh";
            }
        ];
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        initExtraFirst = ''
            export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
            export HISTIGNORE="pwd:ls:cd"
            export EDITOR="lvim"
            export VISUAL="lvim"

            autoload -U up-line-or-beginning-search
            autoload -U down-line-or-beginning-search
            zle -N up-line-or-beginning-search
            zle -N down-line-or-beginning-search
            bindkey "^k" up-line-or-beginning-search # Up
            bindkey "^j" down-line-or-beginning-search # Down
            bindkey '^R' history-incremental-search-backward

            # Needed to enable forward search
            stty -ixon
            bindkey '^S' history-incremental-search-forward

            autoload -Uz compinit
            zstyle ':completion:*' menu select

            # Use vim keys in tab complete menu:
            bindkey -v
            export KEYTIMEOUT=1
            bindkey -v '^?' backward-delete-char

            # Change cursor shape for different vi modes.
            function zle-keymap-select () {
                case $KEYMAP in
                    vicmd) echo -ne '\e[1 q';;      # block
                    viins|main) echo -ne '\e[5 q';; # beam
                esac
            }
            zle -N zle-keymap-select
            zle-line-init() {
                zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
                echo -ne "\e[5 q"
            }
            zle -N zle-line-init
            echo -ne '\e[5 q' # Use beam shape cursor on startup.
            preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

            alias ls='exa -l --color=always --group-directories-first'
            alias ll='ls -la'
        '';
    };
}
