#!/usr/bin/env bash
set -e

# Synopsis:
# Test runner for run.sh in a docker container
# Takes the same arguments as run.sh (EXCEPT THAT SOLUTION AND OUTPUT PATH ARE RELATIVE)
# Builds the Dockerfile
# Runs the docker image passing along the initial arguments

# Arguments:
# $1: exercise slug
# $2: path to solution folder (without trailing slash)
# $3: path to output directory (without trailing slash)

# Output:
# Writes the tests output to the output directory

# Example:
# ./run-in-docker.sh two-fer ./relative/path/to/two-fer/solution/folder/ ./relative/path/to/output-directory/

# If arguments not provided, print usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "usage: ./run-in-docker.sh two-fer ./relative/path/to/two-fer/solution/folder/ ./relative/path/to/output-directory/"
    exit 1
fi

solution_dir=$(realpath $2)
output_dir=$(realpath $3)

# build docker image
docker build -t exercism/wasm-test-runner .

# run image passing the arguments
docker run \
    --network none \
    --read-only \
    --mount type=bind,src=${solution_dir},dst=/solution/ \
    --mount type=bind,src=${output_dir},dst=/output/ \
    --mount type=tmpfs,dst=/tmp \
    exercism/wasm-test-runner $1 /solution/ /output/
