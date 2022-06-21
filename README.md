# R & Python Docker Image

This repo contains a Dockerfile and docker-compose.yml file used to build and run a debian-based Docker image with R and Python installed.

## Specifying R and Python versions

By default, this will install **R version 4.2.0** and **Python version 3.9.13**.  To specify a different version of either R or Python, copy the `.env.template` file to `.env`.  Then, change either the R or Python version(s):

```bash
R_VERSION=4.1.3
PYTHON_VERSION=3.8.9
```

The R version must match an available [Docker r-base tag](https://hub.docker.com/_/r-base?tab=tags).  The Python version must be available to download from [the Python ftp directory](https://www.python.org/ftp/python/).

## Building the Image

To build the image, run `docker compose build`.  

This will create an image named `jannink/analysis`.  Use `docker images` to display the available images.

## Starting a Container

The `docker-compose.yml` file specifies how to run the image in a container.

It sets the container name as `jannink_analysis`.

It will bind-mount the `./scripts` directory from the host into the `/home/analysis/scripts` directory within the container.  You can place scripts and data in this directory and they will be available within the Docker container.  Any output from the container saved in the `/home/analysis/scripts` directory will also be saved on the host.

To start a container running the image, run `docker compose up -d`.  Use `docker container ls` to view running containers.

## Using the Container

By default, the container will not execute any commands or scripts on its own.  To run scripts within the container, start a bash session within the container by running `docker exec -it jannink_analysis bash`

## Stopping the Container

To stop the container, run `docker compose down`.

NOTE:  This will stop and *destroy* the container.  Any data not in the `/home/analysis/scripts` directory will be lost.
