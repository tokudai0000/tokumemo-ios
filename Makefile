# 参考: https://github.com/uhooi/UhooiPicBook/blob/develop/Makefile
# Variables {{{

# Project
product_name := univIP
workspace_name := $(product_name).xcworkspace
package_name := $(product_name)Package

# Production
production_project_name := Production
production_log_name := $(product_name)_$(production_project_name)_Build.log

# Develop
develop_project_name := Develop
develop_log_name := $(product_name)_$(develop_project_name)_Build.log

# Test
TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DESTINATION := 'generic/platform=$(TEST_PLATFORM)'

# Commands
MINT := mint
SWIFTLINT := $(MINT) run realm/SwiftLint swiftlint

# Mint
MINT_ROOT := ./.mint
export MINT_PATH := $(MINT_ROOT)/lib
export MINT_LINK_PATH := $(MINT_ROOT)/bin

# }}}

# Targets {{{

.PHONY: setup
setup:
	$(MAKE) setup-githooks
	$(MAKE) cocoapods-version-setup
	$(MAKE) pod-install
	$(MAKE) install-mint-dependencies
	$(MAKE) copy-google-service-plist-if-needed
	$(MAKE) open

.PHONY: setup-githooks
setup-githooks:
	cp -r .githooks/* .git/hooks
	chmod -R +x .git/hooks

.PHONY: cocoapods-version-setup
cocoapods-version-setup:
	bundle install --path vendor/bundle

.PHONY: install-mint-dependencies
install-mint-dependencies:
#	$(MINT) bootstrap --overwrite y

.PHONY: pod-install
pod-install:
	pod install

.PHONY: copy-google-service-plist-if-needed
copy-google-service-plist-if-needed:
	sh ./Scripts/CopyGoogleServicePlistIfNeeded.sh

.PHONY: open
open:
	open ./$(workspace_name)

.PHONY: clean
clean:
	rm -rf ./$(package_name)/.build/

.PHONY: distclean
distclean:
	rm -rf $(MINT_ROOT)
	rm -rf ./$(production_log_name)
	rm -rf ./$(develop_log_name)
	rm -rf ~/Library/Developer/Xcode/DerivedData
	rm -rf ./$(package_name)/.swiftpm/
	$(MAKE) clean

$(develop_log_name):
	$(MAKE) build-debug-develop

.PHONY: build-debug-production
build-debug-production:
	$(MAKE) build-debug PROJECT_NAME=$(production_project_name)

.PHONY: build-debug-develop
build-debug-develop:
	$(MAKE) build-debug PROJECT_NAME=$(develop_project_name)

.PHONY: build-debug
build-debug:
	set -o pipefail \
&& xcodebuild \
-sdk $(TEST_SDK) \
-configuration $(TEST_CONFIGURATION) \
-workspace $(workspace_name) \
-scheme '$(PROJECT_NAME)' \
-destination $(TEST_DESTINATION) \
-skipPackagePluginValidation \
clean build \
| tee $(product_name)_$(PROJECT_NAME)_Build.log

.PHONY: lint
lint:
	$(SWIFTLINT)

.PHONY: fix
fix:
	$(SWIFTLINT) --fix --format

.PHONY: analyze
analyze: $(develop_log_name)
	$(SWIFTLINT) analyze --fix --compiler-log-path $(develop_log_name)

# }}}
