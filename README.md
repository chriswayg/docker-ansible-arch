# Arch Rolling (latest) Ansible Test Image

[![Travis Automated build](https://travis-ci.org/yawpitch/docker-ansible-arch.svg?branch=rolling)](https://travis-ci.org/yawpitch/docker-ansible-arch/branches)
[![Docker Automated build](https://img.shields.io/docker/automated/yawpitch/docker-ansible-arch-rolling.svg?maxAge=2592000)](https://hub.docker.com/r/yawpitch/docker-ansible-arch-rolling/)

Dockerized Arch Rolling (latest) for Ansible playbook and role tests.

## For Ansible Testing Only 

This image is intended *solely* for automated testing of Ansible playbooks and roles as a local process inside a container running on a CI server such as Jenkins or Travis. It is neither configured nor intended for use in any secure or production environment, and **any use is at your own risk**.

## Getting Started

First, [Install Docker](https://docs.docker.com/engine/installation/), then choose which image to use.

### Option 1: Pull from Docker Hub

Any time a commit is merged to the `master` branch of this repo, **or** any time there is a rebuild of the upstream OS container, an Automatic Build will occur on Docker Hub. You can use this be *pulling* the image to your local machine:

```sh
sudo docker pull yawpitch/docker-ansible-arch-rolling:latest
```

For convenience, a `make pull` target has been provided to do this for you. You can also both pull & verify the current Docker Hub image with the following command:

```sh
make test-hub
```

This will ensure that a container launched with from the image at minimum contains the `ansible` command.

### Option 2: Local build

If you wish to build the image on your local machine, `git clone` this repo, `cd` into the repo, and then run:

```sh
sudo docker build -t docker-ansible-arch-rolling .
```

For convenience, a `make build` target has been provided to do this for you. You can also both build & verify a local image of the current repo with the following command:

```sh
make test-local
```

This will ensure that a container launched with from the image at minimum contains the `ansible` command.

## Use in Ansible playbook & role testing

First, Run a container from the image: 

```sh
docker run --detach --privileged --interactive --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro [IMAGE NAME]:latest
```

To test Ansible roles, add in a volume mounted from the current working directory of the role:

```sh
docker run --detach --privileged --interactive --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro --volume=`pwd`:/etc/ansible/roles/role_under_test:ro [IMAGE NAME]:latest    
```
  
Then use `docker exec` to acccess Ansible inside the container:

```sh
docker exec --tty [container_id] env TERM=xterm ansible --version
docker exec --tty [container_id] env TERM=xterm ansible-playbook /path/to/ansible/playbook.yml --syntax-check
```

## Author

Maintained by Michael Morehouse (yawpitch), slightly modified from the work of [Jeff Geerling](http://jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
