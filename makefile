
.PHONY: version build build_linux docker_login docker_build docker_push_dev docker_push_pro
.PHONY: rm_stop test_rm test_clear docker_test

Version = v0.3.0
GOBIN = $(pwd)
VersionFile = version/version.go
GitCommit = `git rev-parse --short=8 HEAD`
BuildVersion = "`date +%FT%T%z`"
GOBIN = $(shell pwd)

ImagesPrefix = "registry.cn-hangzhou.aliyuncs.com/yuanben/"
ImageName = "kchain"
TestTag = ":test"
ImageNameTest = "kchain:test"

ImageCommitName = "kchain:$(Version)_$(GitCommit)"

version:
	@echo "项目版本处理"
	@echo "package version" > $(VersionFile)
	@echo "const Version = "\"$(Version)\" >> $(VersionFile)
	@echo "const BuildVersion = "\"$(BuildVersion)\" >> $(VersionFile)
	@echo "const GitCommit = "\"$(GitCommit)\" >> $(VersionFile)

build: version
	@echo "开始编译"
	GOBIN=$(GOBIN) go install main.go

build_linux: version
	@echo "交叉编译成linux应用"
	GOBIN=`pwd` CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install main.go

rm_stop:
	@echo "删除所有的的容器"
	sudo docker rm -f $(sudo docker ps -qa)
	sudo docker ps -a

docker_push_pro: docker_build
	@echo "docker push pro"
	docker push $(ImagesPrefix)$(ImageCommitName)
	docker push $(ImagesPrefix)$(ImageName)

docker_push_dev: docker_build
	@echo "docker push test"
	@docker push $(ImagesPrefix)$(ImageNameTest)

docker_build: build_linux
	@echo "构建docker镜像"
	@docker build -t $(ImageName) .
