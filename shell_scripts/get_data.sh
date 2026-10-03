#!/bin/bash

cd /home/analyst/marketplace-analytics
source .venv/bin/activate
python python_scripts/main.py

find /home/analyst/marketplace-analytics/logs -name "*.log" -mtime +21 -delete