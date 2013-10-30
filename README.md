# Knife Docker

Knife Docker is an LXC provisioning tool which performs four things:

* Build a Docker container (with Chef-Solo as the provisioner)
* Run tests against the LXC container using ServerSpec and verify that
  the container is upto scratch.
* Create an artifact of the container (which can either be a DEB package
  or a .tar.gz of the container (or a part of the container)
* Upload the artifact to a specified destination (initial support for S3
  only)

## Building a container

The command will be `knife docker build`

This creates a Docker container with Chef Solo pre-installed on it.

It then rsync's/SCP's the cookbook/playbook to the Docker container and then runs it.

## Verifying the container

The command will be `knife docker verify`

This calls server-spec on the container and verifies it to see if the
spec has passed or failed.

## Building the artifact

The command will be `knife docker build-artifact`

This either creates a debian package or a .tar.gz of the container
(based on the config present in the container)

## Deploying the artifact

The command will be `knife docker deploy-artifact`

This uploads the debian package to a storage service such as S3.
