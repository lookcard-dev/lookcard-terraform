#!/bin/bash

# Create image_tags directory if it doesn't exist
mkdir -p image_tags

# Loop through all terraform.*.tfvars.json files
for tfvars_file in terraform.*.tfvars.json; do
    # Extract environment name from file name
    env_name=${tfvars_file#terraform.}
    env_name=${env_name%.tfvars.json}
    
    echo "Extracting image tags for: $env_name"
    
    # Extract the image_tag section from the JSON file
    jq '.image_tag' "$tfvars_file" > "image_tags/$env_name.json"
    
    echo "Created image_tags/$env_name.json"
done

echo "Image tag extraction complete!" 