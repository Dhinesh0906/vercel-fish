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
unzip -o project.zip -d .

echo "Contents after unzip:"
ls

echo "Project restore complete."
