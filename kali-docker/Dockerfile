FROM kalilinux/kali-linux-docker

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean

# Now install some things
RUN apt-get install -y man-db exploitdb

## Metapackage with top10 most used tools
RUN apt install -y kali-linux-top10
RUN apt install -y pciutils

## Add stuff here to avoid rebuilding expensive layer

# Copy tmux configuration for root user
COPY ./.tmux.conf /root
