# Agent Guidelines

## Build/Test Commands

```bash
make install    # Build container + install emc binary
make test       # Run container validation tests
make build      # Build container only
make clean      # Remove temp files
```

## Key Files

- `emc` - Container wrapper script (bash)
- `Dockerfile` - Fedora-based Emacs container
- `Makefile` - Build automation
- `emacs/init.el` - Emacs configuration

## Container Details

- Base: Fedora 43
- User: emacsuser (UID 1000)
- Workspace: /workspace (mounted from host PWD)
- Emacs config: /home/emacsuser/.emacs.d/init.el

## Adding New Files

1. Edit `Dockerfile` to copy new files to container
2. Update `Makefile` test targets if needed
3. Update README.md with new features