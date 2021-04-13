# aws cli docker container

- fix aws-cli utf-8 character bug.

## multi-arch build

```bash
$ docker buildx create --use --name build
$ docker docker buildx build --push --tag noahxp/aws-cli --platform linux/amd64,linux/arm64 .
```
