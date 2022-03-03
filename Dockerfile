FROM node:16-bullseye-slim as runner
# Node.js 16 (curently LTS)
# Debian bullseye

# fetch latest security updates
# jq is needed to read JSON configuration files
RUN set -ex && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install jq -y && \
    rm -rf /var/lib/apt/lists/*

# add a non-root user to run our code as
RUN adduser --disabled-password --gecos "" appuser

# install our test runner to /opt
WORKDIR /opt/test-runner

# Install pnpm
RUN npm install -g pnpm

# install all the development modules (used for building)
COPY package.json pnpm-lock.yaml .
RUN pnpm install

# Build the test runner
COPY src/ src/
COPY babel.config.cjs tsconfig.json .
RUN pnpm build

# install only the node_modules we need for production
RUN rm -rf node_modules && pnpm install --prod && pnpm store prune

COPY . .

USER appuser
ENTRYPOINT [ "/opt/test-runner/bin/run.sh" ]
