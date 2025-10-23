FROM python:3.12.9

SHELL ["/bin/bash", "-c"]

ENV COMMON_GROUP="icse26-<U2>-<U3>-<U1>"
ENV STUDY_DIR="/home"
ENV ADMIN_GROUP="$COMMON_GROUP-admin"
ENV COMMON_DIR="$STUDY_DIR/common"
ENV JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.14%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.14_7.tar.gz"
ENV JDK_FILE="OpenJDK17U-jdk_x64_linux_hotspot_17.0.14_7.tar.gz"
ENV MAVEN_URL="https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz"
ENV MAVEN_FILE="apache-maven-3.9.9-bin.tar.gz"
ENV VSCODE_COMMIT="4437686ffebaf200fa4a6e6e67f735f3edf24ada"
ENV VSCODE_URL="https://update.code.visualstudio.com/commit:${VSCODE_COMMIT}/linux-x64/stable"
ENV JAVA_HOME="$COMMON_DIR/jdk-17.0.14+7"
ENV MAVEN_HOME="$COMMON_DIR/apache-maven-3.9.9"
ENV M2_HOME="$MAVEN_HOME"
ENV TO_CHANGE="/template/"

RUN apt-get update && apt-get install -y wget libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev libasound2 openssh-server libssl-dev net-tools iputils-ping

# Create dirs and groups
WORKDIR /home
RUN if [ ! -d "$STUDY_DIR" ]; then\
    mkdir $STUDY_DIR;\
fi

RUN if [ ! -d "$COMMON_DIR" ]; then\
    mkdir $COMMON_DIR;\
fi

RUN if [ ! $(getent group $COMMON_GROUP) ]; then\
    groupadd $COMMON_GROUP;\
fi

RUN if [ ! $(getent group "$ADMIN_GROUP") ]; then\
    groupadd "$ADMIN_GROUP";\
fi

# Set up JDK, Maven and Python
WORKDIR $COMMON_DIR

RUN wget -nv -O $JDK_FILE $JDK_URL &&\
        tar -xzf $JDK_FILE &&\
        rm -f $JDK_FILE

RUN wget -nv -O $MAVEN_FILE $MAVEN_URL &&\
        tar -xzf $MAVEN_FILE &&\
        rm -f $MAVEN_FILE

COPY setup-template.sh /
COPY requirements-client.txt /
RUN chmod +x /setup-template.sh && /setup-template.sh

COPY entrypoint.sh /entrypoint.sh

# Create and set up users
RUN chmod +x /entrypoint.sh
RUN chown -R root:root /home/template
RUN chmod -R 700 /home/template

EXPOSE 22

ENTRYPOINT "/entrypoint.sh"
