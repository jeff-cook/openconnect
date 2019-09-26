# OpenConnect client

This is a Docker image to run OpenConnect.
<https://www.infradead.org/openconnect/index.html>

## alpine:edge

`alpine:edge` was chosen for the base image, because at the time `openconnect` was only a package for `edge`.

<https://www.infradead.org/openconnect/nonroot.html> has instructions if you want to run it without root access.

## Configuration

### Configuration via environment variables

All environment variables that start with `OPENCONNECT_` will be converted into command line options.

Except...

* `OPENCONNECT_PASSWORD_FILE` If this files exists it will be directing into stdin.
* `OPENCONNECT_SERVER` This is the variable for OpenConnect to use as server.

### Configuration via file

A `/etc/openconnect/openconnect.conf` file has been created and will be used.
It is blank so it will need to be updated if you want to use it.
Use a `mount` or `config`.
If you want to use a different config file location update the `OPENCONNECT_CONFIG` variable.

## Requirements

* The container needs to run with `privileged` or `--cap-add NET_ADMIN` to be able to create the tunnel device on the host.
* If you are using the tunnel device you will also need to run the container as root. `--user root`

## How to use

Docker allows the use of a running container to be the network for a container.
<https://docs.docker.com/compose/compose-file/#network_mode>

```yaml
services:
  vpn:

  uses_vpn:
    network_mode: "service:vpn"
```

Or reverse that and attach the VPN to the one container that will use it.

## Why a new Docker image

I was looking for an openconnect image that was light weight and minimal.
I needed it to run on a local Docker install for a jump host.

## Health check

Why is there is no Docker `HEALTHCHECK`?

* OpenConnect should close and fail if the VPN tunnel is closed already.
* Any health check should be used to verify the tunnel is up add passing traffic.
  * This is very specific to each environment.
  * A side affect of a good health check would be to keep the tunnel open even when not in use.
