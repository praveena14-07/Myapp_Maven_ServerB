FROM tomcat:latest
RUN rm -rf webapps
RUN mv webapps.dist webapps
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
COPY ./target/my-app.war /usr/local/tomcat/webapps
