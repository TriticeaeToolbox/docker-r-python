ARG R_VERSION
FROM r-base:${R_VERSION}

# Add System build dependencies
# and packages required for R and python
RUN apt-get update && \
    apt-get install -y curl build-essential \
        libcurl4-openssl-dev libxml2-dev \
        zlib1g-dev libffi-dev libssl-dev libbz2-dev libncursesw5-dev libgdbm-dev \
        liblzma-dev libsqlite3-dev tk-dev uuid-dev libreadline-dev

# Create analysis user
WORKDIR /analysis

# Download Python
ARG PYTHON_VERSION
RUN curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
RUN tar -xvf Python-${PYTHON_VERSION}.tgz

# Build Python from source
WORKDIR /analysis/Python-${PYTHON_VERSION}/
RUN ./configure --enable-optimizations --with-ensurepip=install --prefix=/usr/local/
RUN make -j 8
RUN make install
RUN ln -s /usr/local/bin/python3 /usr/local/bin/python
RUN ln -s /usr/local/bin/pip3 /usr/local/bin/pip

# Cleanup Python Installation
WORKDIR /analysis
RUN rm -rf Python-${PYTHON_VERSION}/ 
RUN rm -f Python-${PYTHON_VERSION}.tgz

# Upgrade pip
RUN pip install --upgrade pip

# Install python modules
COPY ./build/python_requirements.txt ./requirements.txt
RUN pip install -r requirements.txt
RUN rm ./requirements.txt

# Install R packages
COPY ./build/R_packages.txt ./R_packages.txt
RUN Rscript -e "dir.create(path=Sys.getenv(\"R_LIBS_USER\"), showWarnings=FALSE, recursive=TRUE)"
RUN while IFS="" read -r p || [ -n "$p" ]; do Rscript -e "install.packages(\"$p\", lib=Sys.getenv(\"R_LIBS_USER\"), repos=\"https://cloud.r-project.org\")"; done < R_packages.txt
RUN rm ./R_packages.txt

# Create scripts directory
RUN mkdir -p /analysis/scripts

# Keep the container running
ENTRYPOINT ["/bin/bash", "-c", "tail -f /dev/null"]
