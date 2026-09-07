#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "========================================"
echo " Archipelago AMP Setup"
echo "========================================"

echo "Checking Archipelago source..."

# GitHub's archive creates Archipelago-main/.
# Move its contents into AMP's application root.
if [ -d "Archipelago-main" ]; then
    echo "Flattening Archipelago-main..."
    cp -a Archipelago-main/. .
    rm -rf Archipelago-main
fi

# Verify that the archive extracted correctly.
if [ ! -f "MultiServer.py" ]; then
    echo "ERROR: MultiServer.py was not found."
    echo "The Archipelago archive did not extract correctly."
    exit 1
fi

if [ ! -f "requirements.txt" ]; then
    echo "ERROR: requirements.txt was not found."
    exit 1
fi

if [ ! -f "ModuleUpdate.py" ]; then
    echo "ERROR: ModuleUpdate.py was not found."
    exit 1
fi

echo "Archipelago source found."

# Archipelago currently supports Python 3.11 through 3.13 on Linux.
# Prefer python3.12, matching Archipelago's current Docker image.
if command -v python3.12 >/dev/null 2>&1; then
    PYTHON=python3.12
elif command -v python3.13 >/dev/null 2>&1; then
    PYTHON=python3.13
elif command -v python3.11 >/dev/null 2>&1; then
    PYTHON=python3.11
else
    echo "ERROR: No supported Python 3.11, 3.12, or 3.13 installation was found."
    echo "Available Python versions:"
    command -v python3 || true
    python3 --version || true
    exit 1
fi

echo "Using Python:"
"$PYTHON" --version

echo "Creating virtual environment..."

if [ ! -x "venv/bin/python" ]; then
    "$PYTHON" -m venv venv
fi

if [ ! -x "venv/bin/python" ]; then
    echo "ERROR: Python virtual environment could not be created."
    exit 1
fi

echo "Upgrading pip..."
./venv/bin/python -m pip install --upgrade pip

echo "Installing Archipelago requirements..."
./venv/bin/python -m pip install -r requirements.txt

echo "Running Archipelago ModuleUpdate..."
./venv/bin/python ModuleUpdate.py -y

echo "========================================"
echo " Archipelago Setup Complete"
echo "========================================"
