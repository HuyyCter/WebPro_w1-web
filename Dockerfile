# Bước 1: Build file WAR bằng Maven
FROM maven:3.8.6-openjdk-11 AS build
COPY . .
RUN mvn clean package

# Bước 2: Chạy ứng dụng bằng Tomcat
FROM tomcat:9.0-jdk11-openjdk-slim
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]