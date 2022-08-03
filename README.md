# vue打包后静态文件web容器
docker镜像源文件，基于gin实现。比使用同系统架构nginx容器更小，配置简单。特指非根目录部署vue打包静态文件时，刷新页面404，访问页面301重定向等nginx容器配置相对复杂且容易出问题。 

该容器是基础服务，没有web页面，需要在前端项目引用，基于该镜像再次构建，将vue打包静态文件放入/static文件夹


# 配置
目前只提供环境变量配置。  
web地址目前未启用,默认开启8080端口。
有需要自行取消WEB_ADDR注释并注释Dockerfile文件EXPOSE端口

## 当前版本环境变量配置
- WEB_RATE：每秒请求数限制，int。不配置/配置格式错误/配置小于等于0时不开启限制。配置大于0时，每秒最多处理请求多少次，超过返回状态码429
- WEB_LOG：是否打印请求日志，bool。不配置/配置格式错误/配置为false不开启请求日志。配置true时，开启请求日志

一般在前端项目配置Dockerfile，把前端打包好的静态文件放入docker镜像里面
非根目录配置，再由nginx上下文匹配
```
# dockerfile
FROM nmx96/mini-web:0.0.1
COPY dist/ /static/adminSystem
COPY dist/index.html /static

# Makefile
VERSION=1.0
IMAGE_NAME=$(shell pwd | xargs basename)
GOPATH:=$(shell go env GOPATH)


.PHONY: docker
docker:
	DOCKER_BUILDKIT=1 docker build -t ${IMAGE_NAME}:${VERSION}-${GIT_TIME} .
	docker system prune -f

# 启动方式docker run
docker run -d --name="web-vue" -p 8080:8080 -e WEB_RATE=1000 -e WEB_LOG=true adminSystem:0.0.1

# 启动方式docker-compose
version: '3.3'

services:
  web-vue:
    image: adminSystem:0.0.1
    ports:
          - 8080:8080
    environment:
      - WEB_RATE=1000
      - WEB_LOG=true	
```