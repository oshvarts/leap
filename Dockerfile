FROM docker.io/opensuse/leap:15.0

MAINTAINER oshvarts@ford.com

ARG TINI_VERSION=0.18.0
ARG TINI_SHA256SUM=eadb9d6e2dc960655481d78a92d2c8bc021861045987ccd3e27c7eae5af0cf33

ENV HOME=/opt/app-root \
    USER_NAME=default \
    USER_UID=1001 \
    SUMMARY="Base, random-user safe Opensuse Leap OS." 

LABEL summary="${SUMMARY}"

RUN set -ex && \
    #################################################################
    ## Use tini as subreaper in container to adopt zombie processes
    #################################################################
    #curl \
    #    --connect-timeout "${CURL_CONNECTION_TIMEOUT:-20}" \
    #    --retry "${CURL_RETRY:-5}" \
    #    --retry-delay "${CURL_RETRY_DELAY:-0}" \
    #    --retry-max-time "${CURL_RETRY_MAX_TIME:-60}" \
    #    --progress-bar \
    #    --location \
    #    --fail \
    #    --show-error \
    #    https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 \
    #    -o /usr/bin/tini && \
    #echo "${TINI_SHA256SUM} /usr/bin/tini" | sha256sum -c - && \
    #chmod 0755 /usr/bin/tini && \
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
    chgrp -R 0 ${HOME} && \
    chmod g=u ${HOME} && \
    #chmod 0775 /usr/bin/entrypoint && \
    #chgrp 0 /usr/bin/entrypoint && \
    chmod 0664 /etc/passwd /etc/group && \
    chmod g=u /etc/passwd /etc/group && \
    ls -la /etc/passwd && ls -la /etc/group

USER $USER_UID

ENTRYPOINT ['/bin/bash', '-c', 'sleep infinity']
