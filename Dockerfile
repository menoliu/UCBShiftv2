FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    unzip \
    git \
    libbz2-dev \
    libssl-dev \
    libffi-dev \
    liblzma-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    tk-dev \
    xz-utils \
    ca-certificates \
    cmake \
    gdebi-core \
    dssp \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.6 from source
RUN wget https://www.python.org/ftp/python/3.6.15/Python-3.6.15.tgz && \
    tar -xzf Python-3.6.15.tgz && \
    cd Python-3.6.15 && \
    ./configure && \
    make -j$(nproc) && \
    make altinstall && \
    ln -s /usr/local/bin/python3.6 /usr/bin/python && \
    /usr/local/bin/python3.6 -m ensurepip && \
    /usr/local/bin/python3.6 -m pip install --upgrade pip

# Set Python and pip explicitly
ENV PYTHON=/usr/local/bin/python3.6
ENV PIP=/usr/local/bin/pip3.6

# Copy your local tarballs and .deb into the image
# (Assume they're in the same directory as the Dockerfile)
COPY ncbi-blast-2.9.0+-x64-linux.tar.gz mTM-align.tar.bz2 CSpred-SideChain.zip ./

# Install BLAST+
RUN tar -xzf ncbi-blast-2.9.0+-x64-linux.tar.gz && \
    cp -r ncbi-blast-2.9.0+/bin/* /usr/local/bin && \
    rm -rf ncbi-blast-2.9.0+

# Install mTM-align
RUN tar -xjf mTM-align.tar.bz2 && \
    cd mTM-align/src && \
    make && \
    cp mTM-align /usr/local/bin && \
    cd ../../ && rm -rf mTM-align

# Add your source code
RUN unzip CSpred-SideChain.zip && \
    cp -r CSpred-SideChain /opt/CSpred && \
    rm -rf CSpred

# Install Python packages
RUN $PIP install --no-cache-dir -r /opt/CSpred/requirements.txt
WORKDIR /opt/CSpred
VOLUME [ "/opt/CSpred/models" ]

# Entry point
ENTRYPOINT ["/usr/local/bin/python3.6", "CSpred.py"]
