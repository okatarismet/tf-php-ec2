# Terraform AWS MySQL Database and PHP Login Page Deployment

This Terraform script automates the deployment of an AWS infrastructure consisting of an RDS MySQL database, VPC, internet gateway, and EC2 instance to host a PHP login page. The login page allows users to input a username and password for authentication.

## Prerequisites

Before you begin, ensure you have the following:

1. [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
2. AWS account credentials with the necessary permissions to create and manage resources.

## Configuration

### AWS Credentials

To deploy this infrastructure, you need to provide your AWS credentials. Add your AWS access key ID and secret access key into the `main.tf` file. Ensure your AWS IAM user or role has the required permissions to create and manage RDS, VPC, EC2, and other necessary resources.

```hcl
provider "aws" {
  region     = "us-west-2" // Specify your desired AWS region
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
}
```

## Deployment

1. Clone this repository to your local machine:

   ```bash
   git clone <repository_url>
   ```

2. Navigate to the cloned directory:

   ```bash
   cd tf-php-ec2
   ```

3. Initialize Terraform:

   ```bash
   terraform init
   ```

4. Review the `main.tf` file to ensure it matches your desired configuration.

5. Apply the Terraform configuration to create the infrastructure:

   ```bash
   terraform apply
   ```

6. After Terraform completes the deployment, note the public IP address of the EC2 instance. You can access the PHP login page using this IP address.

## Accessing the PHP Login Page

Once the deployment is complete, you can access the PHP login page by navigating to the public IP address of the EC2 instance in your web browser.

```
http://<EC2_Public_IP>/login.php
```

## Cleanup

To avoid incurring unnecessary costs, it's essential to destroy the resources once you no longer need them.

1. Run the following command to destroy the infrastructure:

   ```bash
   terraform destroy
   ```

2. Confirm the destruction by entering `yes` when prompted.

## Security Considerations

- **AWS Credentials**: Ensure your AWS credentials are kept secure. Avoid hardcoding them in plain text and consider using AWS IAM roles with temporary credentials for increased security.
- **Network Security**: Configure security groups and network ACLs to restrict access to your resources only from trusted sources.
- **Password Security**: Implement secure password policies and consider using encryption for sensitive data stored in the database.

## Support

If you encounter any issues or have questions, feel free to [create an issue](<repository_issues_url>) in this repository.
