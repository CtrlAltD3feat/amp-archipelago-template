#!/bin/bash
cd "$(dirname "$0")"
git clone https://github.com/ArchipelagoMW/Archipelago.git .
python3 -m venv venv
./venv/bin/pip install -r requirements.txt
./venv/bin/python ModuleUpdate.py
