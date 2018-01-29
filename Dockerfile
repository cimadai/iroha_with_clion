# usage
# 1st console:
## socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
# 2nd console:
## docker run -d -p 50051:50051 -v $IROHA_HOME/build:/build -v $IROHA_HOME:/opt/iroha  -e DISPLAY=<YOUR_IP_ADDRESS>:0 -v /tmp/.X11-unix:/tmp/.X11-unix iroha_with_clion

FROM hyperledger/iroha-docker-develop:v1
MAINTAINER Daisuke Shiamda

USER root

###########################
# 1st: Install Java8
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-oracle

## UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

RUN apt-get update && \
  apt-get dist-upgrade -y

## Remove any existing JDKs
RUN apt-get --purge remove openjdk*

## Install Oracle's JDK
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update && \
  apt-get install -y --no-install-recommends oracle-java8-installer && \
  apt-get clean all
###########################

###########################
# 2nd: Install CLion
RUN apt-get install -y libfontconfig1 libxrender1 libxtst6 libxi6
# Install clion
RUN mkdir -p /home/developer
RUN cd /home/developer
ADD https://download-cf.jetbrains.com/cpp/CLion-2017.3.2.tar.gz .
RUN tar zxvf CLion-2017.3.2.tar.gz
RUN mv clion-2017.3.2 /home/developer/clion

# System settings
RUN echo "fs.inotify.max_user_watches = 524288" >>  /etc/sysctl.conf
RUN sysctl -p --system

###########################

CMD /home/developer/clion/bin/clion.sh
