#!/usr/bin/env bash
set -e

REPO="Dhinesh0906/vercel-fish"
TAG="v.0.0"
ZIP_NAME="FISHnetsih.zip"

BASE_URL="https://github.com/$REPO/releases/download/$TAG"

echo "Downloading full project zip from GitHub Releases..."
curl -L "$BASE_URL/$ZIP_NAME" -o project.zip

echo "Clearing old files (if any)…"
rm -rf unpacked_project
rm -rf src public offline-ai dist

echo "Unzipping project..."
mkdir -p unpacked_project
unzip -o project.zip -d unpacked_project

echo "Scanning for package.json inside zip…"
PACKAGE_LOC=$(find unpacked_project -maxdepth 3 -type f -name package.json | head -n 1 || true)

if [ -z "$PACKAGE_LOC" ]; then
  echo "ERROR: package.json not found inside the zip."
  ls -R unpacked_project
  exit 1
fi

# Folder that contains package.json
PROJECT_DIR=$(dirname "$PACKAGE_LOC")

echo "Found project at: $PROJECT_DIR"
echo "Copying project files into root…"

cp -R $PROJECT_DIR/* .

echo "Project copied. Cleaning temp folder…"
rm -rf unpacked_project

echo "Final check:"
ls -l

if [ ! -f package.json ]; then
  echo "ERROR: package.json missing after copy. Build cannot continue."
  exit 1
fi

echo "Project restore COMPLETE."
