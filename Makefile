VERSION=0.0.1
IMAGE_NAME=$(shell pwd | xargs basename)
GOPATH:=$(shell go env GOPATH)

.PHONY: docker
docker:
	DOCKER_BUILDKIT=1 docker build --build-arg APP_NAME=${IMAGE_NAME} -t ${IMAGE_NAME}:${VERSION} .
	docker system prune -f

.PHONY: push-hub
push-hub:
	docker tag ${IMAGE_NAME}:${VERSION} nmx96/${IMAGE_NAME}:${VERSION}
	docker push nmx96/${IMAGE_NAME}:${VERSION}

.PHONY: push
push:
	docker tag ${IMAGE_NAME}:${VERSION} 192.168.0.53:5000/${IMAGE_NAME}:${VERSION}
	docker push 192.168.0.53:5000/${IMAGE_NAME}:${VERSION}

.PHONY: push-prod
push-prod:
	docker tag ${IMAGE_NAME}:${VERSION} swr.cn-east-3.myhuaweicloud.com/langmy/${IMAGE_NAME}:${VERSION}
	docker push swr.cn-east-3.myhuaweicloud.com/langmy/${IMAGE_NAME}:${VERSION}
