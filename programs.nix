{ pkgs, variables, config, ... }:
let
  inherit (variables) fullName email;
  inherit (config.home) homeDirectory;
in
{
  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableFishIntegration = true;
    nix-index-database.comma.enable = true;

    starship.enable = true;
    starship.settings = {
      git_branch.style = "242";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 8;
      hostname.ssh_only = false;
      hostname.style = "bold green";
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
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
        # TODO: uncomment the next lines if you want to be able to clone private https repos
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

    ssh = {
      enable = true;
      # includes = [
      #   (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
      #     "/home/${userName}/.ssh/config_external"
      #   )
      #   (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
      #     "/Users/${userName}/.ssh/config_external"
      #   )
      # ];
      matchBlocks = {
        "github.com" = {
          identitiesOnly = true;
          identityFile = [ "/run/agenix/github-key" ];
        };
      };
      addKeysToAgent = "yes";
    };

    lazygit = {
      enable = true;
      settings = {
        os.editPreset = "nvim";
        git.paging.pager = "delta --dark --paging=never";
      };
    };

    yazi = {
      enable = true;
      enableFishIntegration = true;
      settings.manager = {
        show_hidden = true;
        ratio = [ 1 3 4 ];
      };
    };

    fish = {
      enable = true;
      # Scoop: run 'scoop install win32yank' on Windows, then add this line to the bottom of interactiveShellInit
      # fish_add_path --append /mnt/c/Users/<Your Windows Username>/scoop/apps/win32yank/0.1.1
      #
      # Chocolatey: run 'choco install win32yank' on Windows, then add this line to the bottom of interactiveShellInit:
      # fish_add_path --append /mnt/c/ProgramData/chocolatey/bin

      interactiveShellInit = ''
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
        refresh = "source $HOME/.config/fish/config.fish";
        take = ''mkdir -p -- "$1" && cd -- "$1"'';
        ttake = "cd $(mktemp -d)";
        show_path = "echo $PATH | tr ' ' '\n'";
        posix-source = ''
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
  };
}
