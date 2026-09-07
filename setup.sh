#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "========================================"
echo " Archipelago AMP Setup"
echo "========================================"

# GitHub's source archive extracts into:
#   Archipelago-main/
#
# AMP expects the application files directly in the
# application directory, so flatten the archive first.
if [ -d "Archipelago-main" ]; then
    echo "Flattening Archipelago-main..."
    cp -a Archipelago-main/. .
    rm -rf Archipelago-main
fi

# Verify that the Archipelago source was downloaded correctly.
if [ ! -f "MultiServer.py" ]; then
    echo "ERROR: MultiServer.py was not found."
    echo "The Archipelago download/extraction step may have failed."
    exit 1
fi

if [ ! -f "requirements.txt" ]; then
    echo "ERROR: requirements.txt was not found."
    echo "The Archipelago download/extraction step may have failed."
    exit 1
fi

if [ ! -f "ModuleUpdate.py" ]; then
    echo "ERROR: ModuleUpdate.py was not found."
    echo "The Archipelago download/extraction step may have failed."
    exit 1
fi

echo "Archipelago source verified."

# Create the Python virtual environment if it doesn't already exist.
if [ ! -x "venv/bin/python" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
else
    echo "Python virtual environment already exists."
fi

echo "Upgrading pip..."
./venv/bin/python -m pip install --upgrade pip

echo "Installing Archipelago requirements..."
./venv/bin/python -m pip install -r requirements.txt

echo "Running Archipelago ModuleUpdate..."
./venv/bin/python ModuleUpdate.py

echo "========================================"
echo " Archipelago AMP Setup Complete"
echo "========================================"
