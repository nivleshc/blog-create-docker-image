# Build a docker image for Hugo using AWS CodeCommit, AWS CodeBuild, AWS CodePipeline and Amazon Elastic Container Registry
This repository contains code for deploying a solution that will automatically create docker images for Hugo when new code is pushed to an AWS CodeCommit repository branch. 

The code is written using Terraform.

The solutions is built using the following AWS services:

AWS CodeCommit
AWS CodeBuild
AWS CodePipeline
Amazon Simple Storage Service (S3)
Amazon Elastic Container Registry
Amazon EventBridge

## Prerequisites
Ensure the following exist before deploying the code.
1. AWS CLI tools are installed and your AWS CLI profile has been configured.
2. git cli has been installed.
3. Terraform binary has been installed.
## Implementation
1. Clone the repository using 

    `git clone https://github.com/nivleshc/blog-create-docker-image.git` 

2. Open *Makefile* in your favourite IDE.
3. Update the following variables, if required 
    - PROJECT_NAME=hugo – this is the project name (set to hugo by default. This name will be used to prefix the name of all the resources. I would recommend to keep it as the default).
    - ENV ?= dev – this is the environment name. This is used to suffix the names of the resources. Leave this to the default (dev) unless you are running this in a different environment.
    - TF_VAR_codepipeline_artifacts_s3_bucket_name = <yours3bucketname> – this is the Amazon S3 bucket where AWS CodePipeline artifacts will be stored. Provide the name of an existing Amazon S3 bucket name here.
4. Open a command prompt (terminal on MacOS, cmd on Windows) and cd into the root of the above cloned folder.
5. Run 
    
    `make terrform_init` 

    This will initialise the terraform project by downloading the required providers.
6. Run 

   `make terraform_plan` 

    This will generate and display the changes that will be done to your AWS Account. The changes will also be saved in a file called hugo_plan.tfplan inside the terraform folder.

7. Run 

    `make terraform_apply`
    
    This will apply the changes to your AWS Account.
    
The full instructions are available at <workdpress link>
