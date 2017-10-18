.PHONY:	pull build _run _test _fail _clean clean-local test-local clean-hub test-hub

THIS := $(lastword $(MAKEFILE_LIST))
OPTS := -f $(THIS) --no-print-directory
CURDIR := $(dir $(realpath $(THIS)))
ifndef IMAGE
IMAGE := $(notdir $(basename $(CURDIR:%/=%)))-$(subst hoverbear/archlinux:,,$(lastword $(shell head Dockerfile -n 1)))
endif
CONTAINER := $(notdir $(basename $(IMAGE)-container))
G = "\033[92m"
R = "\033[91m"
Y = "\033[93m"
N = "\033[0m"
IMAGES := $(shell docker images -q $(IMAGE))
RUNNING := $(shell docker ps --all --quiet --filter ancestor=$(IMAGE))

pull:
	docker pull yawpitch/$(IMAGE):latest

build:
	docker build -t $(IMAGE) $(CURDIR)

_run:
	@ echo Running $(Y)$(CONTAINER)$(N)
	@ docker run --name $(CONTAINER) --interactive --detach --privileged --rm \
		--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro $(IMAGE):latest

_test:	_run
	@ docker exec --tty $(CONTAINER) env TERM=xterm ansible --version
	@ echo $(G)ANSIBLE SUCCESS!$(N)
	@ echo Stopping $(Y)$(CONTAINER)$(N)
	@ docker stop -t 0 $(CONTAINER)

_fail:
	@ echo $(R)ANSIBLE FAIL!$(N)
	@ echo Stopping $(Y)$(CONTAINER)$(N)
	@ docker stop -t 0 $(CONTAINER)

_clean:
	@ if [ "$(RUNNING)" ]; then echo $(Y)Removing containers based on $(IMAGE)$(N); fi
	@ if [ "$(RUNNING)" ]; then docker rm --force --volumes $(RUNNING); fi
	@ if [ "$(IMAGES)" ]; then echo $(Y)Removing images from repo $(IMAGE)$(N); fi
	@ if [ "$(IMAGES)" ]; then docker rmi --force $(IMAGES); fi

clean-local:
	@ $(MAKE) $(OPTS) _clean IMAGE=$(IMAGE)

test-local:	build
	@ $(MAKE) $(OPTS) _test IMAGE=$(IMAGE) \
		|| ($(MAKE) $(OPTS) _fail IMAGE=$(IMAGE) && exit 1)

clean-hub:
	@ $(MAKE) $(OPTS) _clean IMAGE=yawpitch/$(IMAGE)

test-hub:	pull
	@ $(MAKE) $(OPTS) _test IMAGE=yawpitch/$(IMAGE) \
		|| ($(MAKE) $(OPTS) _fail IMAGE=yawpitch/$(IMAGE) && exit 1)

