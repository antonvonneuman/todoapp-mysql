### BUILD image
FROM maven:3.6.1-jdk-8-alpine as builder
# create app folder for sources
RUN mkdir -p /build
WORKDIR /build
COPY pom.xml /build
#Download all required dependencies into one layer
RUN mvn -B dependency:resolve dependency:resolve-plugins
#Copy source code
COPY src /build/src
# Build application
RUN mvn package

FROM tomcat:8.0.51-jre8-alpine
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=builder /build/target/*.war /usr/local/tomcat/webapps/ROOT.war
CMD ["catalina.sh","run"]