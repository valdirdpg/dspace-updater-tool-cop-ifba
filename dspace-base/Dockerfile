ARG JDK_VERSION=8

# Step 1 - Run Maven Build
FROM dspace/dspace-dependencies:dspace-6_x as build
ARG TARGET_DIR=dspace-installer
WORKDIR /app

# RUN yum update -y && yum install -y postgresql && yum clean all

RUN mkdir /install \
    && chown -Rv dspace: /install \
    && chown -Rv dspace: /app

USER dspace

# Copiar TUDO primeiro, incluindo pom.xml
COPY --chown=dspace . /app/

# Depois copiar a configuração local
COPY --chown=dspace dspace/src/main/docker/local.cfg /app/local.cfg

# Build DSpace
RUN mvn package -DskipTests && \
  mv /app/dspace/target/${TARGET_DIR}/* /install && \
  mvn clean

# Step 2 - Run Ant Deploy
FROM eclipse-temurin:8-jdk-alpine as ant_build
ARG TARGET_DIR=dspace-installer
COPY --from=build /install /dspace-src
WORKDIR /dspace-src
ENV ANT_VERSION 1.10.7
ENV ANT_HOME /tmp/ant-$ANT_VERSION
ENV PATH $ANT_HOME/bin:$PATH
RUN apk add --no-cache wget
RUN mkdir $ANT_HOME && \
    wget -qO- "https://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C $ANT_HOME
RUN ant init_installation update_configs update_code update_webapps update_solr_indexes

# Step 3 - Run tomcat
FROM tomcat:9-jre8-temurin
ENV DSPACE_INSTALL=/dspace
COPY --from=ant_build /dspace $DSPACE_INSTALL
EXPOSE 8080 8009
ENV JAVA_OPTS=-Xmx2000m
RUN ln -s $DSPACE_INSTALL/webapps/solr    /usr/local/tomcat/webapps/solr    && \
    ln -s $DSPACE_INSTALL/webapps/xmlui   /usr/local/tomcat/webapps/xmlui   && \
    ln -s $DSPACE_INSTALL/webapps/jspui   /usr/local/tomcat/webapps/jspui   && \
    ln -s $DSPACE_INSTALL/webapps/rest    /usr/local/tomcat/webapps/rest    && \
    ln -s $DSPACE_INSTALL/webapps/oai     /usr/local/tomcat/webapps/oai     && \
    ln -s $DSPACE_INSTALL/webapps/rdf     /usr/local/tomcat/webapps/rdf     && \
    ln -s $DSPACE_INSTALL/webapps/sword   /usr/local/tomcat/webapps/sword   && \
    ln -s $DSPACE_INSTALL/webapps/swordv2 /usr/local/tomcat/webapps/swordv2
