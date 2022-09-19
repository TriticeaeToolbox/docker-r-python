# R & Python Docker Image

This repo contains a Dockerfile used to build a debian-based Docker image with R and Python installed.

It includes the following R packages:

- tidyverse
- dplyr
- devtools
- AlphaSimR
- jeanlucj/BreedSimCost (from GitHub)

And the following python packages:

- botorch
- numpy
- rpy2

All commands should be run within the directory containing the Dockerfile.  If running on BioHPC, replace the `docker` command with `docker1`.

## Specifying R and Python versions

The R and Python versions are specified as build args when building the docker image.

The R version must match an available [Docker r-base tag](https://hub.docker.com/_/r-base?tab=tags).  The Python version must be available to download from [the Python ftp directory](https://www.python.org/ftp/python/).

## Specifying R and Python packages

When the image is built, it will install the packages defined in the `./build/R_packages.txt` and `./build/python_requirements.txt` files.  The `python_requirements.txt` file can [include specific versions](https://pip.pypa.io/en/stable/reference/requirements-file-format/) to install.

## Building the Image

To build the image:

1) First, set the R and Python versions to use:

```bash
export R_VERSION=4.2.0
export PYTHON_VERSION=3.9.13
```

2) (Optional) Change the R and/or python packages to include.

3) Then, run the docker build command:

```bash
docker build -t triticeaetoolbox/r_python:R${R_VERSION}-python${PYTHON_VERSION} --build-arg R_VERSION=${R_VERSION} --build-arg PYTHON_VERSION=${PYTHON_VERSION} .
```

NOTE: You may need to change the last `.` (representing the current working directory) to the full/absolute path of the directory containing the Dockerfile.

This will create an image named `triticeaetoolbox/r_python` with the tag `R4.2.0-python3.9.13` to specify which versions of R and python were used in that build.  Use `docker images` to display the locally available images.

## Transferring an Image

To transfer an image built on one machine to run on a different machine, you can create a .tar archive of the image, transfer it to another machine, and then load the .tar file on the new machine.

1) List the locally available images on the first machine to get the name and tag of the image to transfer

```bash
$ docker images
REPOSITORY                       TAG                   IMAGE ID       CREATED         SIZE
triticeaetoolbox/r_python        R4.1.0-python3.8.0    5fa9fa43651a   14 hours ago    4.28GB
triticeaetoolbox/r_python        R4.2.0-python3.9.13   6ed0ef719546   16 hours ago    4.14GB
```

2) Create a .tar archive of the image

```bash
docker save -o r_python.tar triticeaetoolbox/r_python:R4.2.0-python3.9.13
```

3) Copy the .tar file to the new machine (ie using `scp` or any other file transfer tool)

4) Load the image on the new machine

```bash
docker load -i r_python.tar
```

## Use a Pre-Built Image

To use a pre-built image from Docker Hub, view the [list of available tags](https://hub.docker.com/r/triticeaetoolbox/r_python/tags) for the triticeaetoolbox/r_python image.

To download a specific image, run `docker pull triticeaetoolbox/r_python:R4.2.0-python3.9.13`.

## Starting a Container

To run the image in a new container:

```bash
docker run --name jannink_analysis -v $(pwd)/scripts:/root/scripts -d triticeaetoolbox/r_python:R4.2.0-python3.9.13
```

This will create and run a new container named `jannink_analysis` using the image `triticeaetoolbox/r_python` with the tag `R4.2.0-python3.9.13`.

It will also bind-mount the `./scripts` directory from the host into the `/root/scripts` directory within the container.  You can place scripts and data in this directory and they will be available within the Docker container.  Any output from the container saved in the `/root/scripts` directory will also be saved on the host.

## Using the Container

By default, the container will not execute any commands or scripts on its own.  To run scripts within the container, start a bash session within the container by running `docker exec -it jannink_analysis bash` and then manually execute the scripts in the `/root/scripts` directory.

## Stopping the Container

To stop the container, run `docker stop jannink_analysis`.

To restart the container, run `docker start jannink_analysis`.

To remove the stopped container, run `docker container rm jannink_analysis`.
