FROM ubuntu:22.10

ARG USER=taq
ARG UID=1000
ARG GID=1000
ARG PW=taq

RUN apt update && apt install -y sudo

RUN useradd -m ${USER} --uid=${UID} && echo "${USER}:${PW}" | \
    chpasswd

RUN echo "${USER} ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

# RUN usermod -aG sudo ${USER}

USER ${UID}:${GID}
WORKDIR /home/${USER}
