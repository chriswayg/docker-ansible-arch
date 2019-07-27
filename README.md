# Arch Linux (latest) Ansible Test Image

[![Build Status](https://travis-ci.org/chriswayg/docker-archlinux-ansible.svg?branch=master)](https://travis-ci.org/chriswayg/docker-archlinux-ansible)
[![](https://images.microbadger.com/badges/image/chriswayg/docker-archlinux-ansible.svg)](https://microbadger.com/images/chriswayg/docker-archlinux-ansible)

Arch Linux (latest) Docker container for Ansible playbook and role testing.

## How to Build

This image is built on Docker Hub automatically any time a commit is made or merged to the `master` branch. But if you need to build the image on your own locally, do the following:

  1. [Install Docker](https://docs.docker.com/engine/installation/).
  2. Clone this repository.
  2. `cd` into the repository directory.
  3. Run `docker build -t local-archlinux-ansible .`

## How to Use

  1. [Install Docker](https://docs.docker.com/engine/installation/).
  2. Pull this image from Docker Hub: `docker pull chriswayg/docker-archlinux-ansible:latest` (or use the tag you built earlier, e.g. `local-archlinux-ansible`).
  3. Run a container from the image: (to test my Ansible roles, I add in a volume mounted from the current working directory).
          docker run --detach --privileged --name archlinux_ansible_1 --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro --volume=$(pwd):/etc/ansible/roles/role_under_test:rw chriswayg/docker-archlinux-ansible:latest

  4. Use Ansible inside the container:
    - `docker exec --tty archlinux_ansible_1 env TERM=xterm ansible --version`
    - `docker exec --tty archlinux_ansible_1 env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml --syntax-check`
    - `docker exec --tty archlinux_ansible_1 env TERM=xterm ansible-playbook -vv /etc/ansible/roles/role_under_test/tests/test.yml`

## Notes

I use Docker to test my Ansible roles and playbooks on multiple OSes using CI tools like Travis. This container allows me to test roles and playbooks using Ansible running locally inside the container.

> **Important Note**: I use this image for testing in an isolated environment — not for production — and the settings and configuration used may not be suitable for a secure and performant production environment. Use on production servers at your own risk!

## Authors

- Michael Morehouse (yawpitch), slightly modified from the work of [Jeff Geerling](http://jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
- Modified by Christian Wagner, incorporating more code from [Jeff Geerling's Github repositories](https://github.com/geerlingguy) 'Docker containers for Ansible playbook and role testing', such as `docker-{distro}-ansible`
