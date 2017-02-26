#!/bin/bash

VENV_DIR=/usr/local/pythonenv/pandas-env

echo "Creating the Python virtual environment..."
virtualenv -p /usr/bin/python3.5 --system-site-packages $VENV_DIR

pip install ggplot
