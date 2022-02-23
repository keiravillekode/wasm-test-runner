#!/usr/bin/env bash

if [ -z "$EXERCISM_PRETTIER_VERSION" ]; then
  echo "Pulling prettier version from package.json"
  EXERCISM_PRETTIER_VERSION=$(cat pnpm-lock.yaml | grep -E '^[[:space:]]+prettier: [0-9]' | cut -d':' -f2)
fi

if [ -z "$EXERCISM_PRETTIER_VERSION" ]; then
  echo "---------------------------------------------------"
  echo "This script requires the EXERCISM_PRETTIER_VERSION variable to work."
  echo "Please see https://exercism.org/docs/building/markdown/style-guide for guidance."
  echo "---------------------------------------------------"
  echo "This is what pnpm list reports:"
  echo "$(pnpm list prettier)"
  echo ""
  echo "This is the version that can be extracted:"
  echo "$(pnpm list --pattern prettier | grep -Po '.*\sprettier@\K.*')"
  echo ""
  echo "These files are found in the repo root:"
  echo "$(ls -p | grep -v /)"
  echo "---------------------------------------------------"
  exit 1
else
  echo "Running format with prettier@$EXERCISM_PRETTIER_VERSION"
fi

npx "prettier@$EXERCISM_PRETTIER_VERSION" --write "**/*.{js,jsx,ts,tsx,css,sass,scss,html,json,md,yml}"
