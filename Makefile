APP_NAME = MechSound
BUNDLE_ID = com.mechsound
BUILD_DIR = .build/release
APP_DIR = /Applications/$(APP_NAME).app
PLIST = ~/Library/LaunchAgents/$(BUNDLE_ID).plist
SOUND_SRC = $(HOME)/mechvibes_custom/opera-gx

.PHONY: build clean install uninstall test run

build:
	swift build -c release
	@echo "Built: $(BUILD_DIR)/$(APP_NAME)"

clean:
	swift package clean
	rm -rf .build

test:
	@# Requires Xcode (not just Command Line Tools) for XCTest
	@if xcode-select -p 2>/dev/null | grep -q "Xcode.app"; then \
		swift test; \
	else \
		echo "Skipping tests: XCTest requires Xcode. Tests run in CI."; \
	fi

run: build
	$(BUILD_DIR)/$(APP_NAME)

install: build
	@echo "Installing $(APP_NAME)..."
	@# Create .app bundle
	@mkdir -p "$(APP_DIR)/Contents/MacOS"
	@mkdir -p "$(APP_DIR)/Contents/Resources/sounds/opera-gx"
	@cp $(BUILD_DIR)/$(APP_NAME) "$(APP_DIR)/Contents/MacOS/"
	@cp Resources/Info.plist "$(APP_DIR)/Contents/"
	@cp $(SOUND_SRC)/*.wav "$(APP_DIR)/Contents/Resources/sounds/opera-gx/"
	@# Install launchd agent
	@mkdir -p ~/Library/LaunchAgents
	@sed "s|__APP_PATH__|$(APP_DIR)/Contents/MacOS/$(APP_NAME)|g" \
		scripts/$(BUNDLE_ID).plist > "$(PLIST)"
	@launchctl unload "$(PLIST)" 2>/dev/null || true
	@launchctl load "$(PLIST)"
	@echo "Installed to $(APP_DIR)"
	@echo "LaunchAgent loaded. $(APP_NAME) will auto-start on login."
	@echo ""
	@echo "Grant Accessibility access:"
	@echo "  System Settings > Privacy & Security > Accessibility > enable $(APP_NAME)"

uninstall:
	@echo "Uninstalling $(APP_NAME)..."
	@launchctl unload "$(PLIST)" 2>/dev/null || true
	@rm -f "$(PLIST)"
	@rm -rf "$(APP_DIR)"
	@echo "Removed $(APP_DIR) and launchd agent."
