FROM archlinux/base:latest
LABEL maintainer="Christian Wagner (chriswayg)"
ENV container=docker

# Update, install sudo and systemd, cleanup and remove unneeded unit files.
RUN  pacman -S -y \
  && pacman -S --noconfirm \
    sudo \
    systemd \
  && pacman -S -c --noconfirm

# Install python and Ansible.
RUN pacman -S -y \
  && pacman -S --noconfirm \
    python \
    ansible \
  && pacman -S -c --noconfirm

# Install Ansible inventory file.
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

# Switch default target from graphical to multi-user.
RUN systemctl set-default multi-user.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/usr/lib/systemd/systemd"]
