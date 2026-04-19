# dotfiles

Personal config files. Emacs, fonts, scripts.

## Install

```
./install
./install uninstall
```

Symlinks everything into `$HOME`. Idempotent. Won't clobber existing non-symlink files.

## Adding files

Edit the `@manifest` array in `install`:

```perl
['source/in/repo',  '.config/target/in/home'],   # 1:1
['stuff/*.ext',     '.local/share/stuff/'],       # glob -> directory
```

## What's in here

| Path | Installs to | What |
|---|---|---|
| `emacs/init.el` | `~/.config/emacs/init.el` | Emacs config (Evil, Eglot, Gruvbox) |
| `bin/em` | `~/.local/bin/em` | Launch Emacs daemon client |
| `bin/em-restart` | `~/.local/bin/em-restart` | Restart Emacs daemon |
| `juliamono/*.ttf` | `~/.local/share/fonts/` | JuliaMono + Nerd Font symbols |

## Containerized Emacs Setup

For running Emacs in a container with Podman/Docker:

### Installation
```bash
make install    # Builds container image and installs emc binary
make test       # Tests container validity
make uninstall  # Removes emc binary
```

### Usage
```bash
emc              # Start Emacs GUI with current directory
emc -d           # Start Emacs daemon
emc -c           # Connect to running daemon  
emc -k           # Stop daemon
emc --version    # Show Emacs version
emc --help       # Show full usage
```

### Files
| File | Purpose |
|---|---|
| `Dockerfile` | Alpine-based Emacs container definition |
| `Makefile` | Build, install, and test targets |
| `emc` | Container wrapper script (installs to `/usr/local/bin`) |
