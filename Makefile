APP=${shell basename $(shell git remote get-url origin)}
REGISTRY=shurix

VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/alexanderpanok/kbot/cmd.appVersion=${VERSION}

linux: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/alexanderpanok/kbot/cmd.appVersion=${VERSION}
	
windows: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/alexanderpanok/kbot/cmd.appVersion=${VERSION}

darwin: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/alexanderpanok/kbot/cmd.appVersion=${VERSION}

arm: format get
	CGO_ENABLED=0 GOOS=$(shell uname) GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/alexanderpanok/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot