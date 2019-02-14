FROM docker.io/opensuse/leap:15.0

ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF

ENV HOME=/opt/app-root \
    USER_NAME=default \
    USER_UID=1001 \
    SUMMARY="Base, random-user safe Opensuse Leap OS." 

LABEL \
    summary="$SUMMARY" \
    description="$SUMMARY" \
    io.k8s.description="$SUMMARY" \
    io.k8s.display-name="leap" \
    org.label-schema.name="aos/leap" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-url=$VCS_URL \
    org.label-schema.vcs-ref=$VCS_REF

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
    #################################################################
    # user name recognition at runtime w/ an arbitrary uid
    #################################################################
    chgrp -R 0 ${HOME} && \
    chmod g=u ${HOME} && \
    chmod 0664 /etc/passwd /etc/group && \
    chmod g=u /etc/passwd /etc/group && \
    zypper -n refresh ; zypper -n up ; zypper -n install curl wget iputils; zypper -n clean

WORKDIR $HOME

USER $USER_UID

CMD ["/bin/bash", "-c", "tail -f /dev/null"]
