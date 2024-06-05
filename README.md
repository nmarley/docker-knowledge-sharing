# Docker Knowledge Sharing

We had an informal knowledge sharing session on Docker on 2024-06-05. This
repository contains the notes and code examples from that session.

## Overview - what is Docker & why, containers, cgroups, etc.

Docker is a containerization platform that allows you to package your
application and its dependencies together into a container.

Spelunking docker containers

- `docker create <image>` - create a container from an image
- `docker run -it <image> <command>` - run a container from an image,
    optionally running a command such as a shell

## Files, exploring containers

- `docker ps` - Show running containers
- `docker cp` - copy files from a container to the host or vice/versa
- docker volumes (bind mount) - mount a host file or directory into a container, changes on one are reflected on the other
- `docker inspect <thing>` - get a lot of info about a container, image, network, etc.

## Images

### Making them smaller

scratch image - (empty tar file)
- useful for building very small images with statically linked binaries

exporting / importing images
- docker image save -o <file> <image>
- docker image load -i <file>

Alpine - Linux distribution designed to be small and secure
- known for small images and commonly used as a base for making other images small
- most popular Docker images have an Alpine variant, e.g. postgres, redis, rabbitmq, etc.
- uses musl instead of libc
- can statically link, meaning binaries built this way can be portable (copied to / used on other machines of same architecture)

Debian Slim -- smaller version of Debian, nowhere near as small as Alpine

### Building/Dockerfiles -- build context, layers

- Use `docker build` to build an image from a Dockerfile
- Goes line-by-line thru a Dockerfile and executes [each instruction](https://docs.docker.com/reference/dockerfile/)
- Each instruction is a separate layer
- The fewer layers, the smaller the image

- The build context is the directory where the Dockerfile is located
- Ignore files with `.dockerignore`
- A common technique is to copy only the package manifest, then install packages, then copy the rest of the files
   - This prevents changes to the source code from invalidating the cache for the package installation step (leads to not using cache and running package installs each time the source code is updated)
 
Multi-stage builds - use multiple FROM instructions in a single Dockerfile
- later stages can copy artifacts from earlier stages
- this allows you to build your application in one stage, then copy the built artifacts into a smaller image in a later stage, keeping the final image small and concise
- the _final_ FROM instruction determines the final image

## Docker compose

- Uses `docker-compose.yml` to define a (usually) multi-container application
- options for starting and stopping containers, building images, etc. are defined in the file
- can specify how containers depend on each other

- `docker compose up [-d]` - To start the application (all containers running at once)
    - `[-d]` option runs in detach/daemon mode, meaning in the background
- `docker compose down` - To stop the application (shuts down all containers)
- `docker compose ps` - Show the status of the containers in the application
