# syntax = docker/dockerfile:experimental

#FROM swr.cn-east-3.myhuaweicloud.com/langmy/golang:latest as builder
FROM golang:1.16.9-alpine3.14 as builder
ARG APP_NAME
WORKDIR /build
copy . .
RUN --mount=type=cache,target=/go,id=gomod,sharing=locked \
    GOPROXY=https://goproxy.cn CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -v -tags timetzdata -o ${APP_NAME}

#FROM swr.cn-east-3.myhuaweicloud.com/langmy/alpine:latest
FROM alpine:3.14
ARG APP_NAME
ENV APP_PATH=/${APP_NAME}
COPY --from=builder /build/${APP_NAME} /
EXPOSE 8080
CMD $APP_PATH
