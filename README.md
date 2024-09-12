# Instructions for Deploying Infra Code Using GitHub Actions

### Objective: Deploy infrastructure for an EKS cluster using Terraform through a GitHub Actions workflow.

#### Prerequisites

1. GitHub Repository Secrets:

> AWS_ACCESS_KEY_ID: Your AWS access key.

> AWS_SECRET_ACCESS_KEY: Your AWS secret access key.

> AWS_REGION: The AWS region where resources will be deployed.

> EKS_CLUSTER_NAME: The name of your EKS cluster.

2. Workflow Breakdown:

The workflow consists of the following jobs:
> LogInToAWS: Configures AWS credentials for the workflow.

> TerraformInit: Initializes Terraform.

> TerraformPlan: Generates an execution plan for Terraform.

> TerraformApply: Applies the Terraform configuration.

3. Workflow File:

The workflow file should be saved in your repository at .github/workflows/deploy-eks.yml (or any name you prefer).

4. How to Deploy

- Push Changes to Repository:
> Commit and push your Terraform configuration and workflow file to your GitHub repository.

- Trigger Workflow:
> The workflow is triggered automatically on each push to the repository. Ensure your code is pushed to a branch that is monitored by the workflow.

- Monitor Workflow Execution:
> Go to the "Actions" tab in your GitHub repository to monitor the execution of the workflow. You will see logs for each job, including AWS login, Terraform initialization, planning, and application.

- Verify Deployment:
>Once the workflow completes successfully, verify that the EKS cluster and other resources are created as expected by checking the AWS Management Console or using AWS CLI commands.