FROM tomcat:latest
RUN rm -rf webapps
RUN mv webapps.dist webapps
EXPOSE 8080
RUN rm -rf /usr/local/tomcat/conf/tomcat-users.xml
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY ./target/my-app.war /usr/local/tomcat/webapps
