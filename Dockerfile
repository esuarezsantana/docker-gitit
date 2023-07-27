FROM phusion/baseimage:jammy-1.0.1

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
    gitit \
    graphviz \
    mime-support \
    pandoc-data

# 'COPY etc/ /etc/' will remove sshd service
COPY etc/my_init.d/ /etc/my_init.d/
COPY etc/service/gitit/ /etc/service/gitit/

RUN rm -f /etc/service/sshd/down

ENV MY_DEBUG 0

# These two seems to be ignored by gitit binary.
# ENV GIT_COMMITTER_NAME gitit
# ENV GIT_COMMITTER_EMAIL gitit@example.com

ARG GITIT_PORT 5001
ARG SSH_PORT 22

CMD ["/sbin/my_init"]

EXPOSE ${GITIT_PORT} ${SSH_PORT}
