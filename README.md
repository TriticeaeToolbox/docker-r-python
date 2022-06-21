# R & Python Docker Image

This repo contains a Dockerfile used to build a debian-based Docker image with R and Python installed.

All commands should be run within the directory containing the Dockerfile.  If running on BioHPC, replace the `docker` command with `docker1`.

## Specifying R and Python versions

The R and Python versions are specified as build args when building the docker image.

The R version must match an available [Docker r-base tag](https://hub.docker.com/_/r-base?tab=tags).  The Python version must be available to download from [the Python ftp directory](https://www.python.org/ftp/python/).

## Building the Image

To build the image, run `docker build -t jannink/analysis --build-arg R_VERSION=4.2.0 --build-arg PYTHON_VERSION=3.9.3 .`.  

This will create an image named `jannink/analysis`.  Use `docker images` to display the available images.

## Starting a Container

To run the image in a new container, run `docker run --name jannink_analysis -v $(pwd)/scripts/:/home/analysis/scripts -d jannink/analysis`

This will bind-mount the `./scripts` directory from the host into the `/home/analysis/scripts` directory within the container.  You can place scripts and data in this directory and they will be available within the Docker container.  Any output from the container saved in the `/home/analysis/scripts` directory will also be saved on the host.

## Using the Container

By default, the container will not execute any commands or scripts on its own.  To run scripts within the container, start a bash session within the container by running `docker exec -it jannink_analysis bash`

## Stopping the Container

To stop the container, run `docker stop jannink_analysis`.

To restart the container, run `docker start jannink_analysis`.

To remove the stopped container, run `docker container rm jannink_analysis`.
