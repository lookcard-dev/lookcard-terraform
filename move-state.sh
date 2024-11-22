#!/bin/bash

# Define source and target module paths
SOURCE_MODULE="module.cdn"
TARGET_MODULE="module.security"

# Array of resources to move
RESOURCES=(
  "aws_wafv2_web_acl.portal"
  "aws_wafv2_web_acl_logging_configuration.portal"
)

# Iterate and move each resource
for RESOURCE in "${RESOURCES[@]}"; do
  echo "Moving $RESOURCE from $SOURCE_MODULE to $TARGET_MODULE"
  terraform state mv "$SOURCE_MODULE.$RESOURCE" "$TARGET_MODULE.$RESOURCE"
  if [ $? -ne 0 ]; then
    echo "Failed to move $RESOURCE. Exiting."
    exit 1
  fi
done

echo "State movement completed successfully."
