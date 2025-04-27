## Jenkins Server Infrastructure

The Jenkins server was deployed manually and does not require Terraform configuration. Below are the infrastructure components related to Jenkins:

- **EC2 Instance**: Jenkins was deployed on an EC2 instance in the `us-east-1` region. The EC2 instance has a public IP address and is accessible over HTTP (port 8080).
- **Security Groups**: The EC2 instance uses a security group that allows inbound SSH (port 22) and HTTP (port 8080) traffic.
- **ECR**: Jenkins interacts with an ECR repository to pull Docker images for the frontend and backend services.
- **IAM Roles**: Jenkins has an IAM role with permissions to interact with ECS, ECR, and other AWS services necessary for CI/CD operations.
