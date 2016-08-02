# DOCKER-VERSION 1.0.0
FROM resin/rpi-raspbian:jessie

# install required packages, in one command
RUN apt-get update  && \
    apt-get upgrade -y && \
    apt-get install -y wget git-core
    

# download & install Java JDK
RUN mkdir /tmp/java-jdk && cd /tmp/java-jdk
RUN wget --no-check-certificate http://www.java.net/download/jdk8u60/archive/b25/binaries/jdk-8u60-ea-bin-b25-linux-arm-vfp-hflt-21_jul_2015.tar.gz && \
    tar zxvf jdk-8u60-ea-bin-b25-linux-arm-vfp-hflt-21_jul_2015.tar.gz -C /opt

    
# download & build Minecraft - BuildTools
RUN mkdir /home/minecraft; cd /home/minecraft
RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
    (/opt/jdk1.8.0_60/bin/java -jar BuildTools.jar || true)

# download minecraft-server 1.8.8
RUN mkdir /home/minecraft/spigot-jars; cd /home/minecraft/spigot-jars && \
    wget http://www.mediafire.com/download/kvkkxsu7ws6nhvz/spigot-1.8.8.jar

COPY usr-local-bin--minecraft-server /usr/local/bin/minecraft-server
RUN chmod +x /usr/local/bin/minecraft-server

COPY server.properties /home/minecraft/server.properties
COPY eula.txt /home/minecraft/eula.txt

# Define working directory
WORKDIR /home/minecraft

# Expose minecraft-server port
EXPOSE 25565

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/local/bin/minecraft-server

###############################################################################
##===HOW TO RUN
## docker run -it --rm --name minecraft -p 25565:25565 rajr/rpi-raspbian-minecraft-server minecraft-server 1.8.8
## docker run -d --name minecraft -p 25565:25565 rajr/rpi-raspbian-minecraft-server


