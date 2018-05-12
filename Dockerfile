FROM centos:7 AS build-env

MAINTAINER <pahudnet@gmail.com>

RUN yum update -y && \
yum groupinstall "Development Tools"  -y && \
yum install openssl-devel svn net-tools -y

WORKDIR /root

RUN svn co https://shop.ntop.org/svn/ntop/trunk/n2n && \
cd n2n/n2n_v2 && make && make install

FROM centos:7
COPY --from=build-env /usr/sbin/supernode /usr/sbin/
COPY --from=build-env /usr/sbin/edge /usr/sbin/

