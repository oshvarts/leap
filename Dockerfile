FROM opensuse:leap

MAINTAINER oshvarts@ford.com

ENV HOME=/opt/app-root
ENV USER_NAME=default
ENV USER_UID=1001
ENV SUMMARY="Base, random-user safe Opensuse Leap system." 

LABEL summary="$SUMMARY"

RUN set -ex && \
    #################################################################
    # Add user and group first to make sure their IDs get assigned
    # consistently, regardless of whatever dependencies get added
    # DOCS:
    #   https://linux.die.net/man/8/useradd
    #################################################################
    mkdir -p ${HOME} && \
    groupadd -r ${USER_NAME} -g ${USER_UID} && \
    useradd -l -u ${USER_UID} -r -g 0 -d ${HOME} -s /sbin/nologin -c "${USER_NAME} User" ${USER_NAME} && \
    #usermod -a -G root ${USER_NAME} && \
    #################################################################
    # user name recognition at runtime w/ an arbitrary uid
    #################################################################
    #mkdir -p ${HOME}/etc/vsftpd/certs && \
    #chown -R ${USER_UID}:0 ${HOME} /etc/vsftpd && \
    chgrp -R 0 ${HOME} && \
    chmod g=u ${HOME} && \
    #chmod -R 0644 /etc/pam.d/vsftpd-virtual && \
    #chmod 0775 /usr/bin/entrypoint && \
    #chgrp 0 /usr/bin/entrypoint && \
    chmod 0664 /etc/passwd /etc/group && \
    chmod g=u /etc/passwd /etc/group && \
    ls -la /etc/passwd && ls -la /etc/group

USER 1001
