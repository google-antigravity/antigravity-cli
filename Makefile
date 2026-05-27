.PHONY: install update uninstall check help

BINARY_NAME := agy
INSTALL_DIR := $(HOME)/.local/bin
BINARY_PATH := $(INSTALL_DIR)/$(BINARY_NAME)

help: ## Show this help
	@echo "Antigravity CLI — Makefile targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

install: ## Install Antigravity CLI via official script
	@if [ -f "$(BINARY_PATH)" ]; then \
		echo "✓ agy is already installed at $(BINARY_PATH)"; \
		echo "  Run 'make update' to update, or 'make reinstall' for fresh install."; \
	else \
		echo "⠋ Installing Antigravity CLI..."; \
		bash install.sh; \
		echo ""; \
		echo "✓ Installation complete! Run 'agy' to start."; \
	fi

reinstall: uninstall install ## Remove and reinstall

update: ## Update to the latest version
	@if [ -f "$(BINARY_PATH)" ]; then \
		echo "⠋ Updating Antigravity CLI..."; \
		$(BINARY_PATH) update; \
	else \
		echo "✗ agy is not installed. Run 'make install' first."; \
		exit 1; \
	fi

uninstall: ## Remove Antigravity CLI binary
	@if [ -f "$(BINARY_PATH)" ]; then \
		rm -f "$(BINARY_PATH)"; \
		echo "✓ Removed $(BINARY_PATH)"; \
	else \
		echo "✓ agy is not installed at $(BINARY_PATH)"; \
	fi

check: ## Check if agy is installed and show version
	@if command -v agy >/dev/null 2>&1; then \
		echo "✓ agy found: $$(command -v agy)"; \
		echo "  Version: $$(agy --version 2>/dev/null || echo 'unknown')"; \
	elif [ -f "$(BINARY_PATH)" ]; then \
		echo "✓ agy found at $(BINARY_PATH) (not in PATH)"; \
		echo "  Version: $$($(BINARY_PATH) --version 2>/dev/null || echo 'unknown')"; \
		echo ""; \
		echo "  Add to PATH:"; \
		echo "    export PATH=\"$(INSTALL_DIR):\$$PATH\""; \
	else \
		echo "✗ agy is not installed. Run 'make install'."; \
		exit 1; \
	fi

run: ## Start agy interactive session
	@if command -v agy >/dev/null 2>&1; then \
		agy; \
	elif [ -f "$(BINARY_PATH)" ]; then \
		$(BINARY_PATH); \
	else \
		echo "✗ agy is not installed. Run 'make install' first."; \
		exit 1; \
	fi
