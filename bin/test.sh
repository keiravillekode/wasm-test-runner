#!/bin/bash

set -euo pipefail

pnpm build || exit
pnpm test:bare
