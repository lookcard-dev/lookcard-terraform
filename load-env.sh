#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    # Export all variables from .env file (excluding comments and empty lines)
    set -a
    source .env
    set +a
    echo "Environment variables loaded successfully"
else
    echo ".env file not found - create one from env.example"
fi 