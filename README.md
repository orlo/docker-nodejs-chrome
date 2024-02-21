# docker-nodejs-chrome

A docker container for installing node.js and google chrome

## Building

Perhaps :

```bash
docker build \
    --no-cache \
    --rm \
    -t socialsigninapp/docker-nodejs-chrome:bullseye \
    --pull \
    .

docker push socialsigninapp/docker-nodejs-chrome:bullseye

```
