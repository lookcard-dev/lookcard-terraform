 Infrastructure Deployment README

This repository contains infrastructure as code (IaC) for deploying various services on AWS using Terraform modules. The infrastructure is designed to support a set of microservices for the Look Card platform in a staging environment. Below is an overview of the architecture and instructions for deployment.

 Architecture Overview

The infrastructure is deployed in the `ap-southeast-1` region (Singapore) and consists of the following components:

- Amazon ECS Clusters: Hosting microservices like Authentication, Blockchain, Card, Notification, Reporting, Transaction, Users, Utility, and more.
- Amazon RDS: Managed relational database service for application data storage.
- Amazon DynamoDB: NoSQL database service for fast and flexible data storage.
- Amazon S3: Object storage for various purposes including static website hosting, file uploads, and CDN logs storage.
- Amazon VPC: Virtual Private Cloud for networking isolation.
- Amazon CloudFront: Content Delivery Network for serving static assets with low latency.
- Amazon API Gateway: Service for creating, publishing, maintaining, monitoring, and securing APIs.
- AWS CloudWatch: For monitoring and alerting purposes.
- AWS Lambda: Serverless functions for handling background tasks.
- Amazon Route 53: DNS service for managing domain names.

 Deployment Instructions

Follow these steps to deploy the infrastructure:

1. Clone the Repository: Clone this repository to your local machine.

2. Install Terraform: Make sure you have Terraform installed on your machine. You can download it from [terraform.io](https://www.terraform.io/downloads.html) and follow the installation instructions.

3. Set up AWS Credentials: Ensure you have set up your AWS credentials with appropriate permissions. You can set them up using AWS CLI or by configuring environment variables.

4. Update Variables: Review and update the variables in `variables.tf` file as per your requirements. These variables include VPC CIDR blocks, subnet CIDR blocks, bucket names, domain names, etc.

5. Deploy Infrastructure: Run `terraform init` to initialize the Terraform configuration. Then run `terraform apply` to create the infrastructure. Confirm by typing `yes` when prompted.

6. Accessing Resources: After deployment, Terraform will output important information such as URLs, ARNs, and IDs of resources created. Use this information to access the deployed resources.

7. Cleaning Up: To tear down the infrastructure, run `terraform destroy` and confirm by typing `yes` when prompted. This will remove all the resources created by Terraform.

8.Chaged IAM For Static Resouers Sercers Manager arn


 Contributing

If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request. Contributions are welcome!


```bash
terraform init -backend-config="profile=lookcard-terraform" -backend-config="key=develop/terraform.tfstate"
```