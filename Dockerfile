FROM centos:7

MAINTAINER <pahudnet@gmail.com>

RUN yum update -y && \
yum groupinstall "Development Tools"  -y && \
yum install openssl-devel svn net-tools -y

WORKDIR ['/root']

RUN svn co https://shop.ntop.org/svn/ntop/trunk/n2n && \
cd n2n/n2n_v2 && make && make install && \
rm -rf /root/n2n /var/cache/yum/*

RUN yum groupremove "Development Tools"  -y

