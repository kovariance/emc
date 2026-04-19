# Container runtime detection
CONTAINER_RUNTIME := $(shell command -v podman 2>/dev/null || command -v docker 2>/dev/null)
IMAGE_NAME := emacs-container
BINARY_NAME := emc
INSTALL_DIR := $(HOME)/.local/bin

.PHONY: help clean install uninstall test build

help:
	@echo "Available targets:"
	@echo "  build     - Build the Emacs container image"
	@echo "  install   - Install emc binary to $(INSTALL_DIR)"
	@echo "  test      - Test that the container image is valid"
	@echo "  uninstall - Remove emc binary from $(INSTALL_DIR)"
	@echo "  clean     - Remove local build artifacts"

build:
	@echo "Building Emacs container image using $(CONTAINER_RUNTIME)..."
	$(CONTAINER_RUNTIME) build -t $(IMAGE_NAME) .

install: build
	@echo "Installing $(BINARY_NAME) to $(INSTALL_DIR)..."
	@mkdir -p $(INSTALL_DIR)
	@cp $(BINARY_NAME) $(BINARY_NAME).tmp
	@chmod +x $(BINARY_NAME).tmp
	@install -m 0755 $(BINARY_NAME).tmp $(INSTALL_DIR)/$(BINARY_NAME)
	@rm -f $(BINARY_NAME).tmp
	@echo "Installation complete. Run '$(BINARY_NAME) --help' for usage."

uninstall:
	@echo "Removing $(BINARY_NAME) from $(INSTALL_DIR)..."
	@rm -f $(INSTALL_DIR)/$(BINARY_NAME)
	@echo "Uninstall complete."

test: build
	@echo "Testing container image validity..."
	@$(CONTAINER_RUNTIME) run --rm $(IMAGE_NAME) bash -c "ls /home/emacsuser/.emacs.d/init.el > /dev/null" 2>&1 && \
		echo "✓ Container test passed: Can read ~/.emacs.d/init.el" || \
		(echo "✗ Container test failed: Cannot read ~/.emacs.d/init.el"; exit 1)
	@$(CONTAINER_RUNTIME) run --rm $(IMAGE_NAME) emacs --batch --eval '(message "user-emacs-directory=%s" user-emacs-directory)' 2>&1 | grep -q '.emacs.d' && \
		echo "✓ Container test passed: init.el is loaded from ~/.emacs.d" || \
		(echo "✗ Container test failed: init.el is NOT loaded from ~/.emacs.d"; \
		 $(CONTAINER_RUNTIME) run --rm $(IMAGE_NAME) emacs --batch --eval '(message "user-emacs-directory=%s" user-emacs-directory)' 2>&1; exit 1)
	@$(CONTAINER_RUNTIME) run --rm $(IMAGE_NAME) emacs -nw --batch --eval '(progn (load "~/.emacs.d/init.el") (message "evil-loaded=%s" (featurep (quote evil))))' 2>&1 | grep -q 'evil-loaded=t' && \
		echo "✓ Container test passed: init.el loads packages (evil)" || \
		(echo "✗ Container test failed: init.el does NOT load packages"; \
		 $(CONTAINER_RUNTIME) run --rm $(IMAGE_NAME) emacs -nw --batch --eval '(progn (load "~/.emacs.d/init.el") (message "evil-loaded=%s" (featurep (quote evil))))' 2>&1; exit 1)
	@$(CONTAINER_RUNTIME) run --rm $(IMAGE_NAME) bash -c 'emacs --daemon 2>&1 && emacsclient --eval user-full-name 2>&1' | grep -q 'Michael Tomas Kovarik' && \
		echo "✓ Container test passed: init.el auto-loaded on startup" || \
		(echo "✗ Container test failed: init.el NOT auto-loaded on startup"; \
		 $(CONTAINER_RUNTIME) run --rm $(IMAGE_NAME) bash -c 'emacs --daemon 2>&1 && emacsclient --eval user-full-name 2>&1'; exit 1)
	@$(CONTAINER_RUNTIME) run --rm $(IMAGE_NAME) emacs --version > /dev/null 2>&1 && \
	echo "✓ Container test passed: Emacs runs successfully" || \
	(echo "✗ Container test failed: Emacs failed to run"; exit 1)
	@$(CONTAINER_RUNTIME) run --rm $(IMAGE_NAME) bash --version > /dev/null 2>&1 && \
	echo "✓ Container test passed: Bash runs successfully" || \
	(echo "✗ Container test failed: Bash failed to run"; exit 1)
	@echo "All container tests passed."

clean:
	@echo "Cleaning up..."
	@rm -f $(BINARY_NAME).tmp
	@echo "Clean complete."