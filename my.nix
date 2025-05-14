{ pkgs, ... }:
let
  userInfo = {
    git.username = "hikuohiku";
    git.email = "hikuohiku@gmail.com";
  };
in
{
  home.packages = with pkgs; [
    neovim
    gomi
    ripgrep
    fd
    sd
    bat
    dua
    dust
    lnav
    ranger
    gh
    grc

    uv
    ruff
    nodejs_23
    lua-language-server
    nixfmt

    (stdenv.mkDerivation {
      pname = "copy-to-client-clipboard";
      version = "latest";
      src = fetchurl {
      	url = "https://raw.githubusercontent.com/libapps/libapps-mirror/main/hterm/etc/osc52.sh";
	hash = "sha256-LVsQFVY0YL2ZtksZ0aPBYFujZyHLzbhJzp9oTZHXWTw=";
      };
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
	install -D $src $out/bin/copy
	chmod +x $out/bin/copy
      '';
    })
  ];

  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        ls = "eza --color=auto --icons";
        l = "eza --color=auto --icons -lah";
        ll = "eza --color=auto --icons -l";
        la = "eza --color=auto --icons -a";
        cat = "bat";
        find = "fd";
        grep = "rg";
        sed = "sd";
        top = "btop";
        du = "dua";
        rm = "gomi";
        v = "nvim";
        vi = "nvim";
        vim = "nvim";
        g = "git";
        lg = "lazygit";
        lspath = "echo $PATH | sed 's/ /\\n/g' | sort";
        cp = "cp -r";
        "-" = "prevd";
        "+" = "nextd";
      };
      functions = {
          nr = "nix run nixpkgs#$argv[1] -- $argv[2..]";
      };
      plugins = [
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
      ];
    };
    eza = {
      enable = true;
      enableFishIntegration = false;
    };
    fzf = {
      enable = true;
      enableFishIntegration = false;
      defaultOptions = [
        "--cycle"
        "--layout=reverse"
        "--border"
        "--height=90%"
        "--preview-window=wrap"
        ''--marker="*"''
      ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = userInfo.git.username;
      userEmail = userInfo.git.email;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        pull.rebase = true;
        fetch.prune = true;
      };
      delta = {
        enable = true;
        options = {
          dark = false;
        };
      };
    };
    lazygit = {
      enable = true;
      settings = {
        gui.language = "ja";
        git.paging = {
          colorArg = "always";
          pager = "delta --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format='lazygit-edit://{path}:{line}'";
        };
      };
    };
    zellij.enable = true;
  };

  home.sessionVariables = {
    PAGER = "bat";
  };
}
