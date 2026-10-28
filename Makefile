#
# Task runners for this project's development lifecycle.
#

.PHONY: install uninstall version help

help:
	@echo "Available targets:"
	@echo "  install   - Run the development environment bootstrapper (PROFILE=cli|tui|gui)"
	@echo "  uninstall - Remove programs no longer installed by the bootstrapper"
	@echo "  version   - Tag a release point"
	@echo "  help      - Show this help message"

install:
	./run/install $(if $(PROFILE),--profile=$(PROFILE))

uninstall:
	./run/uninstall

version:
	./run/version
