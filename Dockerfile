FROM node:16-bullseye-slim as runner
# Node.js 16 (curently LTS)
# Debian bullseye

# fetch latest security updates
# curl is required to fetch our webhook from github
# unzip is required for unzipping payloads in development
RUN set -ex \
    apt-get update \
    apt-get upgrade -y \
    apt-get install curl unzip jq -y \
    rm -rf /var/lib/apt/lists/*

# add a non-root user to run our code as
RUN adduser --disabled-password --gecos "" appuser

# install our test runner to /opt
WORKDIR /opt/test-runner
COPY . .

# Install pnpm
RUN npm install -g pnpm

# Build the test runner
# install all the development modules (used for building)
RUN set -ex && pnpm install && pnpm build

# install only the node_modules we need for production
RUN rm -rf node_modules && pnpm install --prod && pnpm store prune

USER appuser
ENTRYPOINT [ "/opt/test-runner/bin/run.sh" ]
