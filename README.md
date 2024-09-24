# gha-environments

GitHub Environments are used to store IAM creds for each AWS account. Two for each AWS account.

* Read Only - Development-READONLY - Read only IAM creds used for terraform plan
* Admin - Development - Full admin IAM creds used for terraform apply. Environment reviewers are required for Admin environments so that the workflow pauses after every Terraform plan job, and approval is required for the apply..

Project wide GitHub Actions secrets are also being used in the build job:

* BUILD_USER_AWS_ACCESS_KEY_ID & BUILD_USER_AWS_SECRET_ACCESS_KEY
 * Used to push Lambda zip to artifacts S3 bucket
* CUSTOM_PAT 
 * Used to checkout github actions from other repos and GitHub Packages node modules

## Workflow jobs

Every jobs starts by checking out a branch.

1.) Build, Audit and Test 

 * Uses BUILD_USER secrets (no reviewers required)
 * Setup node environment
 * npm install + npm build
 * Package lambda zip
 * Upload lambda zip to shared S3 artifacts bucket 

2.) INT Plan

 * Uses INT-READ-ONLY Environment secrets (no environment reviewers required)
 * Terraform Plan (using reusable workflow)

3.) INT Deploy 

 * Uses INT-ADMIN Environment secrets (environment reviewers required so that the build pauses)
 * Terraform Apply (using reusable workflow)
 * Execute Integration Tests

4.) STAGE Plan

 * Uses STAGE-READ-ONLY Environment secrets (no environment reviewers required)
 * Terraform Plan (using reusable workflow)

5.) STAGE Deploy 

 * Uses STAGE-ADMIN Environment secrets (environment reviewers required so that build pauses)
 * Terraform Apply (using reusable workflow)

6.) PROD Plan

* Uses PROD-READ-ONLY Environment secrets (no environment reviewers required)
* Terraform Plan (using reusable workflow)

7.) PROD Deploy 

 * Uses PROD-ADMIN Environment secrets (environment reviewers required so that build pauses)
 * Terraform Apply (using reusable workflow)

8.) Merge PR

 * TODO
