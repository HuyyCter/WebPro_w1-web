# Bước 1: Build file WAR bằng Maven
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Bước 2: Chạy ứng dụng bằng Tomcat 9 (Tương thích tốt nhất với javax.servlet)
FROM tomcat:9.0-jdk11-openjdk-slim

# Xóa trang mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR vào làm ứng dụng gốc (ROOT.war)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Sửa cổng Tomcat 8080 thành biến $PORT động của Render
ENV PORT=8080
EXPOSE 8080
CMD ["sh", "-c", "sed -i \"s/8080/$PORT/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]