#FROM openjdk:8 AS builder
#
#COPY /certs/server.crt /tmp/
#COPY /certs/intermediate.crt /tmp/
#COPY /certs/root.crt /tmp/
#
#RUN keytool -import -v -trustcacerts -alias sonarqube -file /tmp/server.crt \
#    -keystore ${JAVA_HOME}/jre/lib/security/cacerts -noprompt -storepass changeit
#
#RUN keytool -import -v -trustcacerts -alias ca-intermediate -file /tmp/intermediate.crt \
#    -keystore ${JAVA_HOME}/jre/lib/security/cacerts -noprompt -storepass changeit
#
#RUN keytool -import -v -trustcacerts -alias ca-root -file /tmp/root.crt \
#    -keystore ${JAVA_HOME}/jre/lib/security/cacerts -noprompt -storepass changeit
#
#FROM sonarqube:7.8-community
#COPY --from=builder ${JAVA_HOME}/jre/lib/security/cacerts ${JAVA_HOME}/jre/lib/security/cacerts

#sonar-l10n-zh-plugin-1.29.jar
#FROM sonarqube:7.9.1-community

FROM sonarqube:6.7.1

ADD sonar-l10n-zh-plugin-1.19.jar /opt/sonarqube/extensions/plugins/