.PHONY: all install clean

UV ?= uv
SCRIPTS := $(wildcard *.py)
BIN_DIR := ../bin

all: install

install:
	install -d "$(BIN_DIR)"
	for script in $(SCRIPTS); do \
		name=$$(basename "$$script" .py | tr '_' '-'); \
		$(UV) run pyinstaller "$$script" --onefile --name "$$name"; \
		install "dist/$$name" "$(BIN_DIR)/$$name"; \
	done

clean:
	rm -rf build dist *.spec
