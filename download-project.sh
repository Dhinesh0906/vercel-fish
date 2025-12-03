#!/usr/bin/env bash
set -e

REPO="Dhinesh0906/vercel-fish"
TAG="v.0.0"
ZIP_NAME="FISHnetsih.zip"

BASE_URL="https://github.com/$REPO/releases/download/$TAG/$ZIP_NAME"

echo "Downloading full project zip from GitHub Releases..."
curl -L "$BASE_URL" -o project.zip

echo "Clearing old files…"
rm -rf src public offline-ai dist node_modules unpacked_project

echo "Unzipping zip..."
mkdir -p unpacked_project
unzip -o project.zip -d unpacked_project

echo "Searching for package.json at ANY depth…"
PACKAGE_LOC=$(find unpacked_project -maxdepth 5 -type f -name package.json | head -n 1 || true)

if [ -z "$PACKAGE_LOC" ]; then
  echo "❌ ERROR: No package.json found in ANY folder level."
  ls -R unpacked_project
  exit 1
fi

echo "Found package.json at: $PACKAGE_LOC"

PROJECT_DIR=$(dirname "$PACKAGE_LOC")

echo "Copying project files from folder:"
echo "$PROJECT_DIR"

# Clean current root before copying
rm -rf src public offline-ai dist package.json vite.config.* tsconfig.* index.html

# Copy the entire project directory CONTENTS into root
cp -R "$PROJECT_DIR"/* .

echo "Verifying package.json at root…"
if [ ! -f package.json ]; then
  echo "❌ First-level copy failed. Retrying deeper search..."

  PACKAGE_LOC=$(find unpacked_project -maxdepth 8 -type f -name package.json | head -n 1 || true)
  PROJECT_DIR=$(dirname "$PACKAGE_LOC")

  if [ -z "$PACKAGE_LOC" ]; then
    echo "❌ Still no package.json after second search. Project zip is invalid."
    exit 1
  fi

  echo "Retrying copy from: $PROJECT_DIR"

  cp -R "$PROJECT_DIR"/* .
fi

echo "Removing temp folders…"
rm -rf unpacked_project project.zip

echo "ROOT NOW CONTAINS:"
ls -l

if [ ! -f package.json ]; then
  echo "❌ FINAL ERROR: package.json STILL missing in root."
  exit 1
fi

echo "🎉 SUCCESS: Project restored at root and ready to build!"
