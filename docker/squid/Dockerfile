FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y

RUN apt-get update \
  &&  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata

RUN TZ=Asia/Taipei \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install squid -y

# ADD ./squid.conf /etc/squid/
# sed
# http_access deny all
# http_access allow all
RUN sed -i "s/http_access deny all/http_access allow all/g" /etc/squid/squid.conf

ADD ./entrypoint.sh /opt/

RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]

# debconf: delaying package configuration, since apt-utils is not installed