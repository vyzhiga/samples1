ARG DOCKER_REGISTRY=nexus/dmr-docker
FROM ${DOCKER_REGISTRY}/ubi8/openjdk-11-runtime:1.10-10.1638383033
USER root
# prepare repos
RUN rm -rf /etc/yum.repos.d/*
RUN echo -e '\
[rhel-8-for-x86_64-baseos-rpms]\n\
name=Red Hat Enterprise Linux 8 for x86_64 - BaseOS\n\
baseurl=http://lrp/repo/channels-rhel8/rhel-8-for-x86_64-baseos-rpms\n\
failovermethod=priority\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=http://lrp/repo/channels-rhel8/rhel-8-for-x86_64-baseos-rpms/RPM-GPG-KEY-redhat-release\n\
' >> /etc/yum.repos.d/rhel-8-for-x86_64-baseos-rpms.repo
RUN echo -e '\
[rhel-8-for-x86_64-appstream-rpms]\n\
name=Red Hat Enterprise Linux 8 for x86_64 - AppStream\n\
baseurl=http://lrp/repo/channels-rhel8/rhel-8-for-x86_64-appstream-rpms\n\
failovermethod=priority\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=http://lrp/repo/channels-rhel8/rhel-8-for-x86_64-baseos-rpms/RPM-GPG-KEY-redhat-release\n\
' >> /etc/yum.repos.d/rhel-8-for-x86_64-appstream-rpms.repo
# install locales
RUN microdnf install glibc-locale-source glibc-langpack-en glibc-langpack-ru
# dealing with certificates
COPY .certs/*.cer ./
COPY .ca_certs/*.cer /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust; \
    for cert in *.cer; do \
      echo $cert; \
      keytool -import -v -file $cert -alias $(echo $cert | cut -d '.' -f 1) -cacerts -storepass changeit -noprompt; \
    done
# copying builded jar
COPY target/*.jar dmr-business.jar
# setting permissions
RUN chgrp -R 0 /home/jboss && \
    chmod -R g=u /home/jboss
ENTRYPOINT java ${JAVA_ARGS} ${JAVA_SECRET_ARGS} -jar dmr-business.jar
EXPOSE 8080