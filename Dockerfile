FROM maven:3-jdk-8-alpine as MVN_BUILD

WORKDIR /opt/webStack/

ADD . /tmp
RUN cd /tmp && mvn package -DskipTests -Pci && mv target/webStack/* /opt/webStack/ \
&& cp -f /tmp/src/main/resources/docker/* /opt/webStack/WEB-INF/classes/ \
&& mkdir -p /opt/webStack/upload/ && cp -rf src/main/webapp/static/tmp/* /opt/webStack/upload/

FROM openjdk:8-alpine

LABEL maintainer="Zeek Ling<lingzhaohui@zeekling.cn>"

WORKDIR /opt/webStack/
COPY --from=MVN_BUILD /opt/webStack/ /opt/webStack/
#RUN apk add --no-cache ca-certificates tzdata/

ENV TZ=Asia/Shanghai
EXPOSE 8000

ENTRYPOINT [ "java", "-cp", "WEB-INF/lib/*:WEB-INF/classes", "com.jsnjfz.manage.WebstackGunsApplication" ]

