#!/bin/bash

#####################################################
##               脚本已适配验证操作系统               ###
## 统信UOS V20，麒麟V10，CentOS 7.9                  ##
#####################################################

# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible
CUR_DIR="$(pwd)"
SHELL_DIR="$(cd "$(dirname "$0")" && pwd)"
#echo "CD to ${SHELL_DIR} dir to execute scripts"
cd "${SHELL_DIR}" || exit

export openssl_ver=1.1.1w
export python_ver=3.9.18
export ansible_ver=2.15.4

echo 'Install ansible and dependency by sourcecode compile, may be serval minutes...'

if [ ! -f /usr/local/openssl/bin/openssl ]; then
  echo 'Install openssl 1.1.1 ...'
  cd ${SHELL_DIR}/files

  echo ' - openssl install rpm...'
  # yum install --downloadonly --downloaddir=. perl
  find  rpm/perl5/*.rpm  -exec rpm -Uvh --nodeps {} \;
  # yum install --downloadonly --downloaddir=. gcc
  find  rpm/gcc/*.rpm  -exec rpm -Uvh --nodeps {} \;
  # yum install --downloadonly --downloaddir=. zlib zlib-devel
  find  rpm/zlib/*.rpm  -exec rpm -Uvh --nodeps {} \;

  tar -xzf openssl-${openssl_ver}.tar.gz
  cd openssl-${openssl_ver}
  make clean 1>/dev/null
  echo ' - openssl config...'
  ./config --prefix=/usr/local/openssl shared zlib 1>/dev/null
  echo ' - openssl make...'
  make -j4 -q
  echo ' - openssl make install...'
  make  install  1>/dev/null
  ln -s /usr/local/openssl/lib/libssl.so.1.1 /usr/lib64/libssl.so.1.1
  ln -s /usr/local/openssl/lib/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
  echo ' - openssl install complete.'
fi

if [ ! -f /usr/local/python/bin/pip3 ]; then
  echo 'Install python3 ...'
  cd ${SHELL_DIR}/files

  # yum install --downloadonly --downloaddir=. libffi-devel
  echo ' - python3 install libffi rpm...'
  find  rpm/libffi/*.rpm  -exec rpm -Uvh --nodeps {} \;

  tar -xzf Python-${python_ver}.tgz
  cd Python-${python_ver}
  # yum install -y openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel
  make clean 1>/dev/null
  echo ' - python3 configure...'
  ./configure --prefix=/usr/local/python --with-openssl=/usr/local/openssl --enable-optimizations 1>/dev/null
  echo ' - python3 make...'
  make -j4 -q
  echo ' - python3 make install...'
  make install 1>/dev/null
  # 没有就创建链接，有就忽略，避免干扰系统默认版本依赖关系
  ln -s /usr/local/python/bin/python3.9 /usr/bin/python3
  echo ' - python3 install complete.'
fi


if [ ! -f /opt/ansible/bin/ansible ]; then
  echo 'Install ansible ...'
  cd ${SHELL_DIR}/files

  # yum install --downloadonly --downloaddir=. sshpass
  echo ' - ansible install sshpass rpm...'
  find  rpm/sshpass/*.rpm  -exec rpm -Uvh --nodeps {} \;

  tar -xzf ansible-2.15.4.tar.gz
  mv ansible-2.15.4 /opt/ansible
  mkdir /opt/ansible/packages
  # /usr/local/python/bin/pip3 download -d packages -r requirements.txt  -i https://pypi.tuna.tsinghua.edu.cn/simple
  tar -xzf python3_packages.tar.gz -C /opt/ansible/packages/.
  mkdir /etc/ansible
  cp ansible.cfg /etc/ansible/ansible.cfg
  cp ansbile-source.sh /etc/profile.d/.
  cp ansbile-alias.sh /etc/profile.d/.
  chmod +x /etc/profile.d/ansbile-source.sh
  chmod +x /etc/profile.d/ansbile-alias.sh

  cd /opt/ansible
  echo ' - ansible install python3 packages...'
  /usr/local/python/bin/pip3 install --no-index --find-links=${SHELL_DIR}/files/packages -r requirements.txt

  cd ${SHELL_DIR}/files/collections
  echo ' - ansible install collections...'
  # ansible-galaxy collection download community.general ansible.posix
  /usr/local/python/bin/python3 /opt/ansible/bin/ansible-galaxy collection install -r requirements.yml
  echo ' - ansible install complete.'
fi

/etc/profile.d/ansbile-source.sh
/etc/profile.d/ansbile-alias.sh

echo '::::::::::Install complete, print version infor::::::::::::::'
/usr/local/openssl/bin/openssl  version
/usr/local/python/bin/python3 --version
/usr/local/python/bin/pip3 --version
/usr/local/python/bin/python3 /opt/ansible/bin/ansible --version
echo '::::::::::Important: please reconnect SSH enable alias:::::::'

# rm -fr /etc/profile.d/ansbile-source.sh /etc/profile.d/ansbile-alias.sh /etc/ansible/ansible.cfg /usr/local/openssl /usr/local/python /opt/ansible

#echo "CD back to ${CUR_DIR} dir"
cd "${CUR_DIR}" || exit
