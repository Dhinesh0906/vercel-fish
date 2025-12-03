#!/usr/bin/env bash
set -e

REPO="Dhinesh0906/SIH-FISHNET"
TAG="v1.0.0"
ZIP_NAME="FISHnetsih.zip"

BASE_URL="https://github.com/$REPO/releases/download/$TAG"

echo "Downloading full project zip from GitHub Releases..."
echo "URL: $BASE_URL/$ZIP_NAME"

curl -L "$BASE_URL/$ZIP_NAME" -o project.zip

echo "Unzipping project..."
# Unzip into a temp folder so we can control what goes where
rm -rf unpacked_project
mkdir -p unpacked_project
unzip -o project.zip -d unpacked_project

echo "Contents of unpacked_project:"
ls unpacked_project

# CASE 1: zip directly contains package.json at top level
if [ -f unpacked_project/package.json ]; then
  echo "Found package.json at top level of unpacked_project, moving contents to repo root..."
  rm -rf src public offline-ai dist
  cp -R unpacked_project/* .
# CASE 2: zip contains a folder (e.g. FISHnetsih/) that contains package.json
else
  INNER_DIR=$(find unpacked_project -maxdepth 2 -type f -name package.json -printf '%h\n' | head -n 1 || true)

  if [ -z "$INNER_DIR" ]; then
    echo "ERROR: Could not find package.json inside project zip."
    ls -R unpacked_project
    exit 1
  fi

  echo "Found package.json inside: $INNER_DIR"
  echo "Moving that project to repo root..."

  rm -rf src public offline-ai dist
  cp -R "$INNER_DIR"/* .
fi

echo "Final project root contents:"
ls

if [ ! -f package.json ]; then
  echo "ERROR: package.json still not found in repo root after moving."
  exit 1
fi

echo "Project restore complete."
