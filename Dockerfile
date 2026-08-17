# Multi-stage Dockerfile for Form 941 MeF E-Filing System
# Stage 1: Build application with Maven and Java 17
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Production Runtime on Tomcat 9 with Java 17
FROM tomcat:9.0-jdk17-temurin
LABEL maintainer="Enterprise Systems Team <admin@efile941.com>"
LABEL application="IRS Form 941 MeF E-Filing Engine"

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy packaged WAR to Tomcat webapps as ROOT.war
COPY --from=builder /app/target/newdb.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
