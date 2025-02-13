{ pkgs, variables, config, ... }:
let
  inherit (variables) fullName email userName;
  homeDirectory = config.users.users.${userName}.home;
in
{
  home-manager.users.${userName} = {
    programs = {
      home-manager.enable = true;

      nix-index.enable = true;
      nix-index.enableFishIntegration = true;
      nix-index-database.comma.enable = true;

      bat.enable = true;

      eza = {
        enable = true;
        git = true;
        icons = "auto";
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = [ "--cmd cd" ];
      };

      starship = {
        enable = true;
        settings = {
          git_branch.style = "242";
          directory.style = "blue";
          directory.truncate_to_repo = false;
          directory.truncation_length = 8;
          hostname.ssh_only = false;
          hostname.style = "bold green";
        };
      };

      fzf = {
        enable = true;
        enableFishIntegration = true;
        defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
        defaultOptions = [
          "--height 40%"
          "--layout=reverse"
          "--border"
        ];
        fileWidgetCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
        fileWidgetOptions = [
          "--preview 'if test -d {}; eza --tree --all --level=3 --color=always {} | head -200; else; bat -n --color=always --line-range :500 {}; end'"
        ];
        changeDirWidgetCommand = "fd --type d --hidden --strip-cwd-prefix --exclude .git";
        changeDirWidgetOptions = [ "--preview 'eza --tree --color=always {} | head -200'" ];
      };

      yazi = {
        enable = true;
        enableFishIntegration = true;
        settings.manager = {
          show_hidden = true;
          ratio = [ 1 3 4 ];
        };
      };

      # direnv.enable = true;
      # direnv.nix-direnv.enable = true;

      helix = {
        enable = true;
        settings = {
          theme = "tokyonight";
          editor.true-color = true;
          editor.mouse = true;
          editor.cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "block";
          };
        };
      };

      ssh = {
        enable = true;
        matchBlocks = {
          "github.com" = {
            identitiesOnly = true;
            identityFile = [ "/run/agenix/github-key" ];
          };
        };
        addKeysToAgent = "yes";
      };

      git = {
        enable = true;
        package = pkgs.git;
        delta.enable = true;
        delta.options = {
          line-numbers = true;
          side-by-side = true;
          navigate = true;
        };
        userEmail = email;
        userName = fullName;
        signing.key = "/run/agenix/github-key";
        signing.signByDefault = true;
        extraConfig = {
          core.autocrlf = "input";
          merge.conflictstyle = "diff3";
          diff.colorMoved = "default";
          # Uncomment the next lines to clone private https repos
          # url = {
          #   "https://oauth2:${secrets.github_token}@github.com" = {
          #     insteadOf = "https://github.com";
          #   };
          #   "https://oauth2:${secrets.gitlab_token}@gitlab.com" = {
          #     insteadOf = "https://gitlab.com";
          #   };
          # };
          gpg.format = "ssh";
          rebase.autoStash = true;
          rerere.enabled = true;
          pull.rebase = true;
          push.default = "current";
          push.autoSetupRemote = true;
        };
      };

      gh = {
        enable = true;
        # gitCredentialHelper.enable = true;
        # gitCredentialHelper.hosts = [
        #   "https://github.com"
        #   "https://gist.github.com"
        # ];
      };

      lazygit = {
        enable = true;
        settings = {
          os.editPreset = "nvim";
          git.paging.pager = "delta --dark --paging=never";
        };
      };

      fish = {
        enable = true;
        # Scoop: run 'scoop install win32yank' on Windows, then add this line to the bottom of interactiveShellInit
        # fish_add_path --append /mnt/c/Users/<Your Windows Username>/scoop/apps/win32yank/0.1.1
        #
        # Chocolatey: run 'choco install win32yank' on Windows, then add this line to the bottom of interactiveShellInit:
        # fish_add_path --append /mnt/c/ProgramData/chocolatey/bin

        interactiveShellInit = # bash
          ''
            ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
            ${pkgs.lib.strings.fileContents (
              pkgs.fetchFromGitHub {
                owner = "rebelot";
                repo = "kanagawa.nvim";
                rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
                sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
              }
              + "/extras/kanagawa.fish"
            )}

            set -U fish_greeting

            fish_add_path --append /mnt/c/Users/IT-Support/scoop/apps/win32yank/current
            fish_add_path --append /mnt/c/ProgramData/chocolatey/bin

            set show_file_or_dir_preview 'if test -d {}; eza --tree --all --level=3 --color=always {} | head -200; else; bat -n --color=always --line-range :500 {}; end'
          '';
        functions = {
          refresh = # bash
            "source $HOME/.config/fish/config.fish";
          take = # bash
            ''mkdir -p -- "$1" && cd -- "$1"'';
          ttake = # bash
            "cd $(mktemp -d)";
          show_path = # bash
            "echo $PATH | tr ' ' '\n'";
          posix-source = # bash
            ''
              for i in (cat $argv)
                set arr (echo $i |tr = \n)
                set -gx $arr[1] $arr[2]
              end
            '';
        };
        shellAbbrs =
          {
            gc = "nix-collect-garbage --d";
          }
          // {
            ".." = "cd ..";
            "..." = "cd ../../";
            "...." = "cd ../../../";
            "....." = "cd ../../../../";
          }
          // {
            g = "git";
            gs = "git status";
            gss = "git status -s";
            gp = "git push";
            gpl = "git pull";
            gcam = "git commit -a --amend --no-edit";
            gpf = "git push --force-with-lease";
          }
          // {
            yz = "yazi";
            lg = "lazygit";
          }
          // {
            ls = "eza --git --icons=always --color=always --long --no-user --no-permissions --no-filesize --no-time";
            lsa = "eza --git --icons=always --color=always --long --no-user --no-permissions --no-filesize --no-time --all";
            lsl = "eza --git --icons=always --color=always --long";
            ll = "eza --git --icons=always --color=always --long --all";
            lt = "eza --git --icons=always --color=always --long --all --tree --level=2";
            lt2 = "eza --git --icons=always --color=always --long --all --tree --level=3";
            lt3 = "eza --git --icons=always --color=always --long --all --tree --level=4";
            ltg = "eza --git --icons=always --color=always --long --tree --git-ignore";
          }
          // {
            ns = "git add . && sudo nixos-rebuild switch --flake ${homeDirectory}/nixos-wsl";
            nb = "git add . && sudo nixos-rebuild build --flake ${homeDirectory}/nixos-wsl";
            nss = "git add . && sudo nixos-rebuild switch --flake ${homeDirectory}/nixos-wsl && sudo shutdown -h now";
          };
        shellAliases = {
          lspe = "fzf --preview 'if test -d {}; eza --tree --all --level=3 --color=always {} | head -200; else; bat -n --color=always --line-range :500 {}; end'";
          lsp = "fd --max-depth 1 --hidden --follow --exclude .git | fzf --preview 'if test -d {}; eza --tree --all --level=3 --color=always {} | head -200; else; bat -n --color=always --line-range :500 {}; end'";
          pbcopy = "/mnt/c/Windows/System32/clip.exe";
          pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
          explorer = "/mnt/c/Windows/explorer.exe";
        };
        plugins = [
          {
            inherit (pkgs.fishPlugins.autopair) src;
            name = "autopair";
          }
          {
            inherit (pkgs.fishPlugins.done) src;
            name = "done";
          }
          {
            inherit (pkgs.fishPlugins.sponge) src;
            name = "sponge";
          }
        ];
      };

      tmux = {
        enable = true;
        plugins = [ pkgs.tmuxPlugins.catppuccin ];
        extraConfig = # bash
          ''
            set -g default-terminal "$TERM"
            set -ag terminal-overrides ",$TERM:Tc"

            set -g mouse on
            set -g history-limit 10000

            # Make TMUX work with yazi
            set -g allow-passthrough on
            set -ga update-environment TERM
            set -ga update-environment TERM_PROGRAM

            # Avoid ESC delay
            set -s escape-time 0

            # Vim style pane selection
            bind h select-pane -L
            bind j select-pane -D 
            bind k select-pane -U
            bind l select-pane -R

            # Start windows and panes at 1, not 0
            set -g base-index 1
            set -g pane-base-index 1
            set-window-option -g pane-base-index 1
            set-option -g renumber-windows on

            # Use Alt-arrow keys without prefix key to switch panes
            bind -n M-Left select-pane -L
            bind -n M-Right select-pane -R
            bind -n M-Up select-pane -U
            bind -n M-Down select-pane -D

            # Shift arrow to switch windows
            bind -n S-Left  previous-window
            bind -n S-Right next-window

            # Shift Alt vim keys to switch windows
            bind -n M-H previous-window
            bind -n M-L next-window
          '';
      };
    };
  };
}
