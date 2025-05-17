.PHONY: check
check:
	-isort --check .
	-black --check .
	-mypy .
	-pytest -v --color=yes --doctest-modules tests/ src/PACKAGE_NAME


.PHONY: build
build:
	python -m build


.PHONY: release
release: build
	pip install --upgrade twine
	python -m twine upload --repository pypi dist/*


.PHONY: init
init:
	@if [ -z "$(pkgname)" ]; then\
		echo "Usage: make $@ pkgname=<name_here>" >&2;\
		exit 1;\
		fi
	sed -i 's/PACKAGE_NAME/$(pkgname)/g' pyproject.toml
	mkdir -p src/$(pkgname) tests/
	echo '# `$(pkgname)`' > readme.md
	rm -fr .git/
	sed -i '/.PHONY: init/,$$d' makefile
	sed -i '$$d' makefile
	sed -i '$$d' makefile
	sed -i 's/PACKAGE_NAME/$(pkgname)/g' makefile
	git init
	git add readme.md pyproject.toml makefile\
		src/$(pkgname) tests/ .gitignore
	git commit -m "initial commit"
