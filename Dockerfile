FROM quay.io/fedora/fedora:43

RUN dnf -y install emacs git curl wget bash sudo @fonts xdg-utils && dnf clean all

# Create a non-root user for running Emacs
RUN useradd -m -u 1000 emacsuser && \
    echo "emacsuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/emacsuser

# Set up workspace directory
RUN mkdir -p /workspace && chown -R emacsuser:emacsuser /workspace

# Copy Emacs configuration
COPY --chown=emacsuser:emacsuser emacs/ /home/emacsuser/.emacs.d/

# Remove any stale ~/.emacs that would shadow ~/.emacs.d/init.el
RUN rm -f /home/emacsuser/.emacs

USER emacsuser
WORKDIR /home/emacsuser

# Install and byte-compile all packages at build time
RUN emacs --batch --load /home/emacsuser/.emacs.d/init.el 2>&1 || true
RUN emacs --batch --load /home/emacsuser/.emacs.d/init.el --eval '(byte-recompile-directory user-emacs-directory 0 t)' 2>&1 || true

WORKDIR /workspace

# Default command - start Emacs in daemon mode
CMD ["emacs", "--daemon"]
