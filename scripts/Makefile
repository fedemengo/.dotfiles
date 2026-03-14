.PHONY: all install clean install-pys clean-pys

UV ?= uv
PY_SCRIPTS := $(wildcard *.py)
BIN_DIR := ../bin

all: install

install: install-pys clean

# Python CLI scripts compiled with PyInstaller.
# Add parallel install-<toolchain> targets here later for other languages.
install-pys:
	install -d "$(BIN_DIR)"
	for script in $(PY_SCRIPTS); do \
		name=$$(basename "$$script" .py | tr '_' '-'); \
		$(UV) run --with pyinstaller pyinstaller "$$script" --onefile --name "$$name"; \
		install "dist/$$name" "$(BIN_DIR)/$$name"; \
	done

clean: clean-pys

# Remove Python/PyInstaller build artifacts.
# Add parallel clean-<toolchain> targets here later for other languages.
clean-pys:
	rm -rf build dist *.spec
