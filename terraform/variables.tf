variable "env" {
  type        = string
  description = "The name of the environment where this project is being run. eg dev, test, preprod, prod."
}

variable "codecommit_repo_name" {
  type        = string
  description = "The name of the AWS CodeCommit Repository where the code to build the container image for hugo will be stored."
}

variable "codecommit_repo_default_branch_name" {
  type        = string
  description = "The default branch for the AWS CodeCommit Repo"
}

variable "ecr_repo_name" {
  type        = string
  description = "The name of the AWS Elastic Container Repository where the image for hugo will be stored"
}

variable "codebuild_project_name" {
  type        = string
  description = "The name of the AWS CodeBuild project"
}

variable "codebuild_service_role_name" {
  type        = string
  description = "The name of the AWS CodeBuild Project's service role"
}

variable "image_tag_prefix" {
  type        = string
  description = "The prefix to use when tagging the newly build docker image"
}

variable "codepipeline_pipeline_name" {
  type        = string
  description = "The name of the AWS CodePipeline pipeline"
}

variable "codepipeline_role_name" {
  type        = string
  description = "The name of the AWS CodePipeline role"
}

variable "codepipeline_role_policy_name" {
  type        = string
  description = "The name of the AWS CodePipeline role policy"
}

variable "cloudwatch_events_role_name" {
  type        = string
  description = "The name for the AWS CloudWatch Events role policy"
}

variable "cloudwatch_events_role_policy_name" {
  type        = string
  description = "The name for the AWS CloudWatch Events role policy"
}

variable "cloudwatch_events_rule_name" {
  type        = string
  description = "The name of the AWS CloudWatch Event rule that will trigger the image build pipeline"
}

variable "codepipeline_artifacts_s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket where CodePipeline will store its artifacts"
}

variable "codebuild_cloudwatch_logs_group_name" {
  type        = string
  description = "The cloudwatch logs group name for CodeBuild"
}

variable "codebuild_cloudwatch_logs_stream_name" {
  type        = string
  description = "The cloudwatch logs stream name for CodeBuild"
}