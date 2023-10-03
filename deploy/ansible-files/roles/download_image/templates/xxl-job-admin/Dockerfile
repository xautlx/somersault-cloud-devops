# 官方镜像没有ARM64版本，做一层转换以便支持多PCU架构
FROM --platform=linux/amd64 xuxueli/xxl-job-admin:{{xxl_job_admin_version}} as xxljob

# https://github.com/xuxueli/xxl-job/blob/master/xxl-job-admin/Dockerfile
FROM openjdk:8-jre-slim
MAINTAINER xuxueli

ENV PARAMS=""

ENV TZ=PRC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=xxljob /app.jar /home/app.jar

RUN apt-get update
RUN apt-get install -y net-tools iputils-ping telnet

ENTRYPOINT ["sh","-c","java -jar $JAVA_OPTS /home/app.jar $PARAMS"]