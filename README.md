# R & Python Docker Image

This repo contains a Dockerfile used to build a debian-based Docker image with R and Python installed.

All commands should be run within the directory containing the Dockerfile.  If running on BioHPC, replace the `docker` command with `docker1`.

## Specifying R and Python versions

The R and Python versions are specified as build args when building the docker image.

The R version must match an available [Docker r-base tag](https://hub.docker.com/_/r-base?tab=tags).  The Python version must be available to download from [the Python ftp directory](https://www.python.org/ftp/python/).

## Building the Image

To build the image, run `export R_VERSION=4.2.0; export PYTHON_VERSION=3.9.13; docker build -t triticeaetoolbox/r_python:R${R_VERSION}-python${PYTHON_VERSION} --build-arg R_VERSION=${R_VERSION} --build-arg PYTHON_VERSION=${PYTHON_VERSION} .`.

This will create an image named `triticeaetoolbox/r_python` with the tag `R4.2.0-python3.9.13` to specify which versions of R and python were used in that build.  Use `docker images` to display the locally available images.

## Use a Pre-Built Image

To use a pre-built image from Docker Hub, view the [list of available tags](https://hub.docker.com/r/triticeaetoolbox/r_python/tags) for the triticeaetoolbox/r_python image.

To download a specific image, run `docker pull triticeaetoolbox/r_python:R4.2.0-python3.9.13`.

## Starting a Container

To run the image in a new container, run `docker run --name jannink_analysis -v $(pwd)/scripts/:/home/analysis/scripts -d triticeaetoolbox/r_python:R4.2.0-python3.9.13`.

This will create and run a new container named `jannink_analysis` using the image `triticeaetoolbox/r_python` with the tag `R4.2.0-python3.9.13`.

It will also bind-mount the `./scripts` directory from the host into the `/home/analysis/scripts` directory within the container.  You can place scripts and data in this directory and they will be available within the Docker container.  Any output from the container saved in the `/home/analysis/scripts` directory will also be saved on the host.

## Using the Container

By default, the container will not execute any commands or scripts on its own.  To run scripts within the container, start a bash session within the container by running `docker exec -it jannink_analysis bash`

## Stopping the Container

To stop the container, run `docker stop jannink_analysis`.

To restart the container, run `docker start jannink_analysis`.

To remove the stopped container, run `docker container rm jannink_analysis`.
