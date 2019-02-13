

server: clean generate
	hexo server

deploy: generate
	hexo deploy

generate:
	hexo generate

clean:
	hexo clean