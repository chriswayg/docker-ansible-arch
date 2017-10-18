FROM hoverbear/archlinux:latest
LABEL maintainer="Michael Morehouse (yawpitch)"

# Install dependencies.
RUN pacman -S -y \
  && pacman -S --noconfirm \
    python2-appdirs \
    python2-asn1crypto \
    python2-bcrypt \
    python2-cffi \
    python2-crypto \
    python2-cryptography \
    python2-enum34 \
    python2-idna \
    python2-jinja \
    python2-markupsafe \
    python2-packaging \
    python2-pip \
    python2-pyasn1 \
    python2-pyparsing \
    python2-yaml \
    python2-paramiko \
    ca-certificates \
  && pip2 install --upgrade pip \
  && pacman -S -c --noconfirm

# Install Ansible
RUN pip2 install ansible

# Install Ansible inventory file.
COPY hosts /etc/ansible/hosts

CMD ["/bin/bash"]
