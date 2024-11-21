#!/bin/bash

# Array of subnet resources to process
# resources=(
#   "module.VPC.aws_subnet.database-subnet[0]"
#   "module.VPC.aws_subnet.database-subnet[1]"
#   "module.VPC.aws_subnet.database-subnet[2]"
#   "module.VPC.aws_subnet.isolated-subnet[0]"
#   "module.VPC.aws_subnet.isolated-subnet[1]"
#   "module.VPC.aws_subnet.isolated-subnet[2]"
#   "module.VPC.aws_subnet.private-subnet[0]"
#   "module.VPC.aws_subnet.private-subnet[1]"
#   "module.VPC.aws_subnet.private-subnet[2]"
#   "module.VPC.aws_subnet.public-subnet[0]"
#   "module.VPC.aws_subnet.public-subnet[1]"
#   "module.VPC.aws_subnet.public-subnet[2]"
# )

# # Loop through each resource and extract the ID
# for resource in "${resources[@]}"; do
#   # Extract the subnet ID
#   subnet_id=$(terraform state show "$resource" 2>/dev/null | grep -E "^\s*id\s*=" | awk '{print $3}' | tr -d '"')
  
#   # Check if the ID was found
#   if [ -n "$subnet_id" ]; then
#     echo "Resource: $resource, Subnet ID: $subnet_id"
#   else
#     echo "Resource: $resource, Subnet ID: Not Found"
#   fi
# done


# Resource: module.VPC.aws_subnet.database-subnet[0], Subnet ID: subnet-0a51b929e28eaa865
# Resource: module.VPC.aws_subnet.database-subnet[1], Subnet ID: subnet-0eaf48f2fbe1c75b7
# Resource: module.VPC.aws_subnet.database-subnet[2], Subnet ID: subnet-0e24bdfd88b261fbb
# Resource: module.VPC.aws_subnet.isolated-subnet[0], Subnet ID: subnet-0d16afe0e1c944e6d
# Resource: module.VPC.aws_subnet.isolated-subnet[1], Subnet ID: subnet-0c0d675a3b6d7b397
# Resource: module.VPC.aws_subnet.isolated-subnet[2], Subnet ID: subnet-038dc726747d2fdd8
# Resource: module.VPC.aws_subnet.private-subnet[0], Subnet ID: subnet-0552c770b244ecae6
# Resource: module.VPC.aws_subnet.private-subnet[1], Subnet ID: subnet-05224c025aa8f813b
# Resource: module.VPC.aws_subnet.private-subnet[2], Subnet ID: subnet-06502050d6cdc3a72
# Resource: module.VPC.aws_subnet.public-subnet[0], Subnet ID: subnet-0fde32e510fe1f40a
# Resource: module.VPC.aws_subnet.public-subnet[1], Subnet ID: subnet-0c4b5d5807a5c1cdb
# Resource: module.VPC.aws_subnet.public-subnet[2], Subnet ID: subnet-064410856ab2cb64c

#!/bin/bash

# List of subnet resources to process
resources=(
  # "module.VPC.aws_subnet.database-subnet[0]"
  # "module.VPC.aws_subnet.database-subnet[1]"
  # "module.VPC.aws_subnet.database-subnet[2]"
  # "module.VPC.aws_subnet.isolated-subnet[0]"
  # "module.VPC.aws_subnet.isolated-subnet[1]"
  # "module.VPC.aws_subnet.isolated-subnet[2]"
  # "module.VPC.aws_subnet.private-subnet[0]"
  # "module.VPC.aws_subnet.private-subnet[1]"
  # "module.VPC.aws_subnet.private-subnet[2]"
  # "module.VPC.aws_subnet.public-subnet[0]"
  # "module.VPC.aws_subnet.public-subnet[1]"
  # "module.VPC.aws_subnet.public-subnet[2]"
)

# Loop through each resource and process it
for resource in "${resources[@]}"; do
  echo "Processing resource: $resource"

  # Step 1: Get the current subnet ID
  subnet_id=$(terraform state show "$resource" 2>/dev/null | grep -E "^\s*id\s*=" | awk '{print $3}' | tr -d '"')

  if [ -z "$subnet_id" ]; then
    echo "Error: Subnet ID not found for $resource. Skipping..."
    continue
  fi

  echo "Found Subnet ID: $subnet_id for $resource"

  # Step 2: Remove the current module resource from the state
  echo "Removing $resource from state..."
  terraform state rm "$resource"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to remove $resource from state. Skipping..."
    continue
  fi

  # Step 3: Import the resource with the new name
  new_resource_name=$(echo "$resource" | sed 's/-/_/g') # Replace '-' with '_'
  echo "Importing $subnet_id to $new_resource_name..."
  terraform import -var-file="terraform.tfvars.dev.json" "$new_resource_name" "$subnet_id"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to import $new_resource_name with Subnet ID $subnet_id. Skipping..."
    continue
  fi

  echo "Successfully processed $resource."
done
