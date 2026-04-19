# Emacs Configuration & Container Setup

Personal dotfiles with an Emacs config and containerized Emacs environment.

## Project Structure

| Path | Installs to | What |
|---|---|---|
| `emacs/init.el` | `~/.config/emacs/init.el` | Emacs config |
| `bin/em` | `~/.local/bin/em` | Launch Emacs daemon client |
| `bin/em-restart` | `~/.local/bin/bin/em-restart` | Restart Emacs daemon |
| `juliamono/*.ttf` | `~/.local/share/fonts/` | JuliaMono + Nerd Font symbols |
| `emc` | `/usr/local/bin/emc` | Container wrapper (via `make install`) |

## Containerized Emacs

Runs Emacs in a Podman/Docker container with Fedora.

### Quick Start

```bash
make install    # Build container image and install emc binary
emc             # Start Emacs terminal in container
```

### Make Targets

| Target | Description |
|---|---|
| `make build` | Build the Emacs container image |
| `make install` | Build image and install emc binary to `~/.local/bin` |
| `make test` | Run container validation tests |
| `make uninstall` | Remove emc binary |
| `make clean` | Remove build artifacts |

### emc Usage

```bash
emc              # Start Emacs terminal (default)
emc -g           # Start Emacs GUI (Wayland)
emc file.txt     # Open file.txt in Emacs
emc -d           # Start Emacs daemon
emc -c           # Connect to running daemon
emc -k           # Stop daemon
emc --version    # Show Emacs version in container
emc --help       # Show help
```

### Environment Variables

- `EMC_WORKSPACE` - Directory to mount as /workspace (default: PWD)
- `EMC_IMAGE` - Container image name (default: emacs-container)

## Emacs Features

- **Evil** - Vim keybindings
- **Eglot** - LSP client (Python, Julia, Java)
- **Company** - Auto-completion
- **Flycheck** - Syntax checking
- **Magit** - Git interface
- **Gruvbox** - Theme (light-soft)
- **Doom-modeline** - Status line
- **Org-modern** - Org mode styling
- **Julia-snail** - Julia REPL integration
