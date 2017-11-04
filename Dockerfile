FROM hoverbear/archlinux:latest
LABEL maintainer="Michael Morehouse (yawpitch)"

# Install Ansible.
RUN pacman -S -y \
  && pacman -S --noconfirm ansible \
  && pacman -S -c --noconfirm

# Install Ansible inventory file.
COPY hosts /etc/ansible/hosts

CMD ["/bin/bash"]
