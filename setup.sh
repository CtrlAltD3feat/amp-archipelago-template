#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "=== Archipelago AMP Setup ==="

# GitHub's source archive extracts into Archipelago-main/.
# Move its contents into the AMP application root so that
# MultiServer.py, requirements.txt, ModuleUpdate.py, etc.
# are where the AMP template expects them.
if [ -d "Archipelago-main" ]; then
    echo "Flattening Archipelago source directory..."
    cp -a Archipelago-main/. .
    rm -rf Archipelago-main
fi

# Make sure the expected Archipelago files exist.
if [ ! -f "requirements.txt" ]; then
    echo "ERROR: requirements.txt was not found."
    exit 1
fi

if [ ! -f "MultiServer.py" ]; then
    echo "ERROR: MultiServer.py was not found."
    exit 1
fi

if [ ! -f "ModuleUpdate.py" ]; then
    echo "ERROR: ModuleUpdate.py was not found."
    exit 1
fi

echo "Creating Python virtual environment..."
python3 -m venv venv

echo "Upgrading pip..."
./venv/bin/python -m pip install --upgrade pip

echo "Installing Archipelago dependencies..."
./venv/bin/python -m pip install -r requirements.txt

echo "Running Archipelago module update..."
./venv/bin/python ModuleUpdate.py

echo "=== Archipelago AMP Setup Complete ==="
