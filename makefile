path := .

define Comment
	- Run `make help` to see all the available options.
	- Run `make lint` to run the linter.
	- Run `make lint-check` to check linter conformity.
	- Run `dep-lock` to lock the deps in 'requirements.txt' and 'requirements-dev.txt'.
	- Run `dep-sync` to sync current environment up to date with the locked deps.
endef


.PHONY: help
help: ## Show this help message.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


.PHONY: lint
lint: black isort flake mypy	## Apply all the linters.


.PHONY: lint-check
lint-check:  ## Check whether the codebase satisfies the linter rules.
	@echo
	@echo "Checking linter rules..."
	@echo "========================"
	@echo
	@black --check $(path)
	@isort --check $(path)
	@flake8 $(path)


.PHONY: black
black: ## Apply black.
	@echo
	@echo "Applying black..."
	@echo "================="
	@echo
	@black --fast $(path)
	@echo


.PHONY: isort
isort: ## Apply isort.
	@echo "Applying isort..."
	@echo "================="
	@echo
	@isort $(path)


.PHONY: flake
flake: ## Apply flake8.
	@echo
	@echo "Applying flake8..."
	@echo "================="
	@echo
	@flake8 $(path)


.PHONY: mypy
mypy: ## Apply mypy.
	@echo
	@echo "Applying mypy..."
	@echo "================="
	@echo
	@mypy $(path)


.PHONY: install-deps
install-deps: ## Install all the dependencies.
	@pip install -e .[dev_deps]


.PHONY: test
test: ## Run the tests against the current version of Python.
	@export PYTHONWARNINGS="ignore" && pytest -s -v


.PHONY: build
build: ## Build the CLI.
	@rm -rf build/ dist/
	@python -m build

.PHONY: upload
upload: build ## Build and upload to PYPI.
	@twine upload dist/*
