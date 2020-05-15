FROM ubuntu:18.04

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa

# Dependencies
RUN apt-get update \
    && apt-get install -y \
        build-essential \  
        wget \
        curl \
        git \
        maven \
        openjdk-11-jdk \
        ssh-client \
        unzip \
        iputils-ping \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get --only-upgrade install maven -y

RUN mvn --version

# Install nvm with node and npm
ENV NODE_VERSION=8.9.4 \
    NVM_DIR=/root/.nvm \
    NVM_VERSION=0.33.8

RUN curl https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Set node path
ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Default to UTF-8 file.encoding
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

# Xvfb provide an in-memory X-session for tests that require a GUI
ENV DISPLAY=:99

# Set the path.
ENV PATH=$NVM_DIR:$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Create dirs and users
RUN mkdir -p /opt/atlassian/bitbucketci/agent/build \
    && sed -i '/[ -z \"PS1\" ] && return/a\\ncase $- in\n*i*) ;;\n*) return;;\nesac' /root/.bashrc \
    && useradd --create-home --shell /bin/bash --uid 1000 pipelines

#AWS
RUN apt-get update && apt-get install -y python3-pip
RUN pip3 install -U awscli
RUN aws --version

# Download kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

WORKDIR /opt/atlassian/bitbucketci/agent/build
ENTRYPOINT /bin/bash
