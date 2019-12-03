

server: install clean build
	npm run server

deploy:
	npm run deploy

build:
	npm run build

clean:
	npm run clean

install:
	npm install

pull_all:
	git submodule update --init
	git submodule foreach -q --recursive 'branch="$$(git config -f $$toplevel/.gitmodules submodule.$$name.branch)"; git checkout $$branch'