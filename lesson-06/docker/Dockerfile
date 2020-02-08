ARG TYPORA_VERSION=0.9.75
ARG TYPORA_RELEASE=1
ARG NGINX_PORT=8080


FROM centos:latest AS builder

ARG TYPORA_VERSION
ARG TYPORA_RELEASE

RUN yum install -y rpm-build yum-utils && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY typora.spec /tmp/typora.spec

RUN yum-builddep /tmp/typora.spec && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    sed -i 's/TYPORA_VERSION/'"${TYPORA_VERSION}"'/; s/TYPORA_RELEASE/'"${TYPORA_RELEASE}"'/' /tmp/typora.spec && \
    rpmbuild -bb /tmp/typora.spec && \
    cp /root/rpmbuild/RPMS/x86_64/typora-"${TYPORA_VERSION}"-"${TYPORA_RELEASE}".el7.x86_64.rpm /tmp && \
    rm -rf /root/rpmbuild /tmp/typora.spec



FROM centos:latest

ARG TYPORA_VERSION
ARG TYPORA_RELEASE
ARG NGINX_PORT

RUN yum install -y epel-release && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN yum install -y nginx createrepo && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    mkdir -p /usr/share/nginx/html/repos/otus/x86_64/Packages

COPY nginx.conf /etc/nginx

RUN sed -i 's/NGINX_PORT/'"${NGINX_PORT}"'/' /etc/nginx/nginx.conf

COPY --from=builder /tmp/typora-"${TYPORA_VERSION}"-"${TYPORA_RELEASE}".el7.x86_64.rpm /usr/share/nginx/html/repos/otus/x86_64/Packages

RUN createrepo /usr/share/nginx/html/repos/otus/x86_64/

EXPOSE ${NGINX_PORT}

ENTRYPOINT ["/usr/sbin/nginx"]
