#!/bin/bash
docker pull amazon/aws-cli

docker build -t="noahxp/aws-cli" .
