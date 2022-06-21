ARG R_VERSION
FROM r-base:${R_VERSION}

# Add System build dependencies
RUN apt-get update && \
    apt-get install -y curl build-essential \
        zlib1g-dev libffi-dev libssl-dev libbz2-dev libncursesw5-dev libgdbm-dev \
        liblzma-dev libsqlite3-dev tk-dev uuid-dev libreadline-dev

# Create analysis user
RUN useradd -ms /bin/bash analysis
ENV PATH="/home/analysis/.local/bin:${PATH}"
USER analysis
WORKDIR /home/analysis

# Download Python
ARG PYTHON_VERSION
RUN curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
RUN tar -xvf Python-${PYTHON_VERSION}.tgz

# Build Python from source
WORKDIR /home/analysis/Python-${PYTHON_VERSION}/
RUN ./configure --enable-optimizations --with-ensurepip=install --prefix=/home/analysis/.local/
RUN make -j 8
RUN make install
RUN ln -s /home/analysis/.local/bin/python3 /home/analysis/.local/bin/python
RUN ln -s /home/analysis/.local/bin/pip3 /home/analysis/.local/bin/pip

# Cleanup Python Installation
WORKDIR /home/analysis
RUN rm -rf Python-${PYTHON_VERSION}/ 
RUN rm -f Python-${PYTHON_VERSION}.tgz

# Upgrade pip
RUN pip install --upgrade pip

# Install python modules
RUN pip install botorch numpy rpy2


# Keep the container running
ENTRYPOINT ["/bin/bash", "-c", "tail -f /dev/null"]
