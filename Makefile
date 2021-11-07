.PHONY: clean
clean: ## Rebuild cached directories.
	flutter clean && flutter pub get

.PHONY: analyze
analyze: ## Run code analyzer
	flutter analyze

.PHONY: format 
format: ## Format code
	flutter format lib/

.PHONY: test 
test: ## Run all unit and widget tests
	flutter test --coverage --test-randomize-ordering-seed random
	genhtml coverage/lcov.info -o coverage/
	open coverage/index.html

.PHONY: run-dev
run-dev: ## Run app in debug mode
	flutter run --target lib/main.dart

.PHONY: run-prd
run-prd: ## Run app in release mode
	flutter run --release --target lib/main.dart

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
