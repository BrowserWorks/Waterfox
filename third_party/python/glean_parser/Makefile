.PHONY: clean clean-test clean-pyc clean-build docs help

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -fr {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

lint: ## check style with flake8
	python3 -m flake8 glean_parser tests
	python3 -m black --check glean_parser tests setup.py
	python3 -m yamllint glean_parser tests
	python3 -m mypy glean_parser

test: ## run tests quickly with the default Python
	py.test

coverage: ## check code coverage quickly with the default Python
	coverage run --source glean_parser -m pytest
	coverage report -m
	coverage html

docs: ## generate Sphinx HTML documentation, including API docs
	rm -f docs/glean_parser.rst
	rm -f docs/modules.rst
	sphinx-apidoc -o docs/ glean_parser
	$(MAKE) -C docs clean
	$(MAKE) -C docs html

release: dist ## package and upload a release
	twine upload dist/*

dist: clean ## builds source and wheel package
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist

install: clean ## install the package to the active Python's site-packages
	pip install .

install-kotlin-linters: ## install ktlint and detekt for linting Kotlin output
	test -f ktlint || curl -sSLO https://github.com/shyiko/ktlint/releases/download/0.29.0/ktlint
	echo "03c9f9f78f80bcdb44c292d95e4d9abf221daf5e377673c1b6675a8003eab94d *ktlint" | sha256sum -c -
	chmod a+x ktlint
	test -f detekt-cli.jar || curl -sSL --output "detekt-cli.jar" https://github.com/detekt/detekt/releases/download/v1.16.0/detekt-cli-1.16.0-all.jar
	echo "dd63aae60cce4b0516ffc11d31b6280d4010ab481754c7e49b2c9e78db877ca4 *detekt-cli.jar" | sha256sum -c -
