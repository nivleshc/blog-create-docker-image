# define global variables
TF_FOLDER := ./terraform
TF_PLAN_FILENAME := hugo_plan.tfplan

PROJECT_NAME=hugo
ENV ?= dev

# define terraform variables
TF_VAR_codecommit_repo_default_branch_name = main
TF_VAR_codepipeline_artifacts_s3_bucket_name = <yours3bucketname>

# the tag to use for the docker image. Format I have used is
# {hugo version}_{platform}_{base docker image}
# In this case:
# hugo version = 0.110.0_ext
# platform = amd64
# base docker image = debian_stable-20230109-slim
TF_VAR_image_tag_prefix = 0.110.0_ext_amd64_debian_stable-20230109-slim

TF_VAR_env = ${ENV}
TF_VAR_codecommit_repo_name = ${PROJECT_NAME}_${ENV}
TF_VAR_ecr_repo_name = ${PROJECT_NAME}_${ENV}
TF_VAR_codebuild_project_name = ${PROJECT_NAME}_${ENV}_imagebuild
TF_VAR_codebuild_service_role_name = ${PROJECT_NAME}-${ENV}-codebuild-service-role
TF_VAR_codepipeline_pipeline_name = ${PROJECT_NAME}_${ENV}_imagebuild_pipeline
TF_VAR_codepipeline_role_name = ${PROJECT_NAME}_${ENV}_codepipeline_role
TF_VAR_codepipeline_role_policy_name = ${TFVAR_codepipeline_role_name}_policy
TF_VAR_cloudwatch_events_role_name = ${PROJECT_NAME}_${ENV}_cloudwatch_events_role
TF_VAR_cloudwatch_events_role_policy_name = ${TFVAR_cloudwatch_events_role_name}_policy
TF_VAR_cloudwatch_events_rule_name = ${PROJECT_NAME}_${ENV}_trigger_imagebuild_pipeline
TF_VAR_codebuild_cloudwatch_logs_group_name = ${PROJECT_NAME}_${ENV}_imagebuildloggroup
TF_VAR_codebuild_cloudwatch_logs_stream_name = ${PROJECT_NAME}_${ENV}_imagebuildlogstream

.EXPORT_ALL_VARIABLES:

.PHONY: terraform_fmt terraform_init terraform_plan terraform_apply terraform_destroy

all: usage

usage:
	@echo
	@echo === Help: Command Reference ===
	@echo make terraform_fmt     - format the terraform files in the standard style.
	@echo make terraform_init    - initialise the terraform project.
	@echo make terraform_plan    - create a plan for the changes that will be deployed.
	@echo make terraform_apply   - apply the changes from the plan stage
	@echo make terraform_destroy - destroy all that was deployed
	@echo make - show this help
	@echo 

terraform_fmt:
	terraform -chdir=${TF_FOLDER} fmt -recursive .	
	
terraform_init:
	terraform -chdir=${TF_FOLDER} init

terraform_plan:
	terraform -chdir=${TF_FOLDER} plan -out=${TF_PLAN_FILENAME}

terraform_apply:
	terraform -chdir=${TF_FOLDER} apply ${TF_PLAN_FILENAME}

terraform_destroy:
	terraform -chdir=${TF_FOLDER} destroy