# Base Docker Image.
FROM centos:6.6

# Update the Base Image and install all prerequisites.
RUN yum -y update && \
    yum -y groupinstall "X Window System" "Fonts" && \
    yum -y install wget unzip mesa-libGLU alsa-lib libpng12 SDL

# Set the Nuke environment variables.

ARG NUKE_MAJOR=10
ARG NUKE_MINOR=5
ARG NUKE_PATCH=8


ENV NUKE_MAJOR=${NUKE_MAJOR}
ENV NUKE_MINOR=${NUKE_MINOR}
ENV NUKE_PATCH=${NUKE_PATCH}
ENV NUKE_VERSION=${NUKE_MAJOR}.${NUKE_MINOR}v${NUKE_PATCH}

# creates working directories and user nuke
RUN mkdir -p /app/Nuke${NUKE_VERSION} && mkdir -p /usr/local/foundry/FLEXlm
RUN useradd -rmU -s /bin/bash nuke
RUN chown nuke:nuke /app/Nuke${NUKE_VERSION}
USER nuke
WORKDIR /home/nuke

RUN wget -P /tmp/ \
    https://thefoundry.s3.amazonaws.com/products/nuke/releases/${NUKE_VERSION}/Nuke${NUKE_VERSION}-linux-x86-release-64.tgz &&\
    tar -C /tmp -xvzf /tmp/Nuke${NUKE_VERSION}-linux-x86-release-64.tgz &&\
    unzip /tmp/Nuke${NUKE_VERSION}-linux-x86-release-64-installer -d /app/Nuke${NUKE_VERSION} &&\
    rm -vf /tmp/*

USER root
RUN ln -s /app/Nuke${NUKE_VERSION}/Nuke${NUKE_MAJOR}.${NUKE_MINOR} /usr/local/bin/Nuke
RUN ln -s /app/Nuke${NUKE_VERSION}/Nuke${NUKE_MAJOR}.${NUKE_MINOR} /usr/local/bin/Nuke${NUKE_MAJOR}.${NUKE_MINOR}


ENV PATH=${PATH}:/app/Nuke${NUKE_VERSION}
ENV PYTHON_PATH=/app/Nuke${NUKE_VERSION}

EXPOSE 4101

ARG foundry_LICENSE=4101@192.168.1.3
ENV foundry_LICENSE=${foundry_LICENSE}


# Set additional ENV's specially for Nuke
ENV NUKE_DISK_CACHE /tmp/nuke

# Entry Flags.
CMD ["Nuke"]
