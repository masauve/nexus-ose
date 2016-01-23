FROM rhel:latest

MAINTAINER Jochen Cordes <jcordes@redhat.com>

EXPOSE 8081

ENV NEXUS_VERSION 2.12.0-01
ENV NEXUS_HOME /opt/nexus/nexus
ENV NEXUS_WORK /sonatype-work
ENV NEXUS_REPOS /repositories

# Install OpenJDK,tar
RUN yum install -y java-1.8.0-openjdk-headless.x86_64 tar

# Install jq
RUN curl --fail --silent --location --retry 3 \
    https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    -o /usr/local/bin/jq \
    && chmod 755 /usr/local/bin/jq

# Install the binaries
RUN mkdir -p /opt/nexus/nexus \
  && curl --fail --silent --location --retry 3 \
    https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-${NEXUS_VERSION}-bundle.tar.gz \
  | gunzip \
  | tar x -C /tmp nexus-${NEXUS_VERSION} \
  && mv /tmp/nexus-${NEXUS_VERSION}/* /opt/nexus/nexus/ \
  && rm -rf /tmp/nexus-${NEXUS_VERSION}

RUN  chmod 777 $NEXUS_HOME \ 
   && mkdir -p $NEXUS_WORK && chmod -R 777 $NEXUS_WORK \
   && mkdir -p $NEXUS_REPOS && chmod -R 777 $NEXUS_REPOS \
   && mkdir -p /conf && chmod -R 777 /conf

RUN groupadd -r nexus -g 185 && useradd -u 185 -r -g nexus -m -d /home/nexus -s /sbin/nologin -c "Nexus user" nexus

COPY scripts/readinessProbe.sh /usr/local/bin/readinessProbe.sh
COPY scripts/fixPermissions.sh /usr/local/bin/fixPermissions.sh
COPY scripts/addrepo.sh /usr/local/bin/addrepo.sh
COPY scripts/addjbossrepos.sh /usr/local/bin/addjbossrepos.sh

RUN chmod 755 /usr/local/bin/fixPermissions.sh 
RUN chmod 755 /usr/local/bin/readinessProbe.sh
RUN chmod 755 /usr/local/bin/addrepo.sh
RUN chmod 755 /usr/local/bin/addjbossrepos.sh
RUN  /usr/local/bin/fixPermissions.sh /opt/nexus
RUN  /usr/local/bin/fixPermissions.sh $NEXUS_WORK
RUN  /usr/local/bin/fixPermissions.sh $NEXUS_REPOS
RUN  /usr/local/bin/fixPermissions.sh /conf

USER nexus

VOLUME ["/sonatype-work"]
VOLUME ["/repositories"]

WORKDIR $NEXUS_HOME
ENV CONTEXT_PATH /
ENV MAX_HEAP 768m
ENV MIN_HEAP 256m
ENV JAVA_OPTS -server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true
ENV LAUNCHER_CONF ${NEXUS_HOME}/conf/jetty.xml ${NEXUS_HOME}/conf/jetty-requestlog.xml
CMD java \
  -Dnexus-work=${NEXUS_WORK} -Dnexus-webapp-context-path=${CONTEXT_PATH} -Dapplication-conf=${NEXUS_HOME}/conf \
  -Xms${MIN_HEAP} -Xmx${MAX_HEAP} \
  -cp '/opt/nexus/nexus/conf/:/opt/nexus/nexus/lib/*' \
  ${JAVA_OPTS} \
  org.sonatype.nexus.bootstrap.Launcher ${LAUNCHER_CONF}
