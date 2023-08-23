# 为了实现跨平台安装nodejs并且能自动适配不同架构平台，采用从官方镜像提取node程序方式
FROM node:{{node_version}} as node
FROM maven:{{maven_version}} as maven

FROM  jenkins/jenkins:{{jenkins_version}}
USER root
WORKDIR /root

# 设置时区确保正确打印日志时间信息
ENV TZ Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone

# https://mirrors.tuna.tsinghua.edu.cn/help/debian/
RUN echo '\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free\n\
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free\n\
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free\n\
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free\n\
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free\n\
' > /etc/apt/sources.list

RUN echo net.ipv6.conf.all.disable_ipv6=1 >> /etc/sysctl.conf
RUN echo net.ipv6.conf.default.disable_ipv6=1  >> /etc/sysctl.conf
RUN echo net.ipv6.conf.lo.disable_ipv6=1  >> /etc/sysctl.conf

RUN apt-get update

# docker & docker compose
RUN  apt-get install -y ca-certificates curl gnupg
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 安装解压缩工具
RUN apt-get install -y xz-utils zip

COPY --from=node  /usr/local/bin/node  /usr/local/bin/node
COPY --from=node  /usr/local/lib/node_modules  /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

RUN node -v
RUN npm -v
RUN npm config set registry https://registry.npm.taobao.org
RUN npm install -g yarn@1.22.19
RUN yarn -v
# 忽略引擎版本检查导致编译终止
RUN yarn config set ignore-engines true
# Error: error:0308010C:digital envelope routines::unsupported
ENV NODE_OPTIONS --openssl-legacy-provider

# https://uniapp.dcloud.net.cn/quickstart-cli.html
RUN npm install -g @vue/cli@5.0.8

COPY --from=maven  /usr/share/maven  /usr/share/maven
ENV M2_HOME /usr/share/maven
ENV PATH $M2_HOME/bin:$PATH
RUN echo 'export M2_HOME=/usr/share/maven' >> /etc/profile
RUN echo 'export PATH=$M2_HOME/bin:$PATH' >> /etc/profile
RUN mvn -v

RUN apt-get install -y net-tools iputils-ping dnsutils telnet iproute2 sshpass

RUN apt-get install -y ansible
RUN mkdir -p /etc/ansible
RUN echo "[defaults]" >> /etc/ansible/ansible.cfg
RUN echo "host_key_checking = False" >> /etc/ansible/ansible.cfg
RUN ansible-galaxy collection install --no-deps community.general
RUN ansible --version

# https://github.com/wagoodman/dive
COPY dive_0.9.2_linux_amd64.deb dive_0.9.2_linux_amd64.deb
RUN apt install ./dive_0.9.2_linux_amd64.deb

# 预先配置： https://github.com/jenkinsci/docker/blob/master/README.md#preinstalling-plugins
# 当前插件列表生成方式：
# yum -y install perl perl-devel
# curl -sSL "http://admin:xxx@127.0.0.1:8080/jenkins/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/'
#RUN sed -i "s#https://updates.jenkins.io/download#https://mirrors.tuna.tsinghua.edu.cn/jenkins#g" /var/jenkins_home/updates/default.json
#RUN sed -i "s#http://www.google.com#https://www.baidu.com#g" /var/jenkins_home/updates/default.json

ENV JENKINS_UC https://updates.jenkins-zh.cn
ENV JENKINS_UC_DOWNLOAD https://mirrors.tuna.tsinghua.edu.cn/jenkins
ENV JENKINS_OPTS="-Dhudson.model.UpdateCenter.updateCenterUrl=https://updates.jenkins-zh.cn/update-center.json"
ENV JENKINS_OPTS="-Djenkins.install.runSetupWizard=false"

COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

