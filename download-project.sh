#!/usr/bin/env bash
set -e

REPO="Dhinesh0906/vercel-fish"
TAG="v.0.0"
ZIP_NAME="FISHnetsih.zip"

BASE_URL="https://github.com/$REPO/releases/download/$TAG/$ZIP_NAME"

echo "Downloading full project zip from GitHub Releases..."
curl -L "$BASE_URL" -o project.zip

echo "Clearing old files (if any)…"
rm -rf src public offline-ai dist node_modules unpacked_project

echo "Unzipping project..."
mkdir -p unpacked_project
unzip -o project.zip -d unpacked_project

echo "Scanning for package.json inside zip…"
PACKAGE_LOC=$(find unpacked_project -type f -name package.json | head -n 1 || true)

if [ -z "$PACKAGE_LOC" ]; then
  echo "ERROR: package.json not found inside the zip."
  echo "Dumping extracted structure..."
  ls -R unpacked_project
  exit 1
fi

PROJECT_DIR=$(dirname "$PACKAGE_LOC")

echo "Found project folder at: $PROJECT_DIR"
echo "Copying project files into root…"

cp -R "$PROJECT_DIR"/* .

echo "Cleaning temp folder…"
rm -rf unpacked_project project.zip

echo "Final check:"
if [ ! -f package.json ]; then
  echo "ERROR: package.json missing after copy. Build cannot continue."
  exit 1
fi

echo "Project restore COMPLETE."
