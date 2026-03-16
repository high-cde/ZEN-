#!/bin/bash

echo "Running FULL ZEN ECOSYSTEM BUILD and DEPLOY"

# ---------------------------------------------------------
# RUN FULL BUILD
# ---------------------------------------------------------

if [ -f build-all.sh ]; then
  bash build-all.sh
else
  echo "ERROR: build-all.sh not found"
  exit 1
fi

# ---------------------------------------------------------
# GIT DEPLOY
# ---------------------------------------------------------

git add .
git commit -m "Full ZEN ecosystem autobuild and deploy"
git push

echo "FULL DEPLOY COMPLETE"
