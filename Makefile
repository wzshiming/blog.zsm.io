

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
	pip3 install yq

pull_all:
	git clone --depth 1 -b $$(cat _config.yml | yq -j '.deploy.branch') $$(cat _config.yml | yq -j '.deploy.repo') .deploy_git
	git clone --depth 1 https://github.com/theme-next/hexo-theme-next themes/next
