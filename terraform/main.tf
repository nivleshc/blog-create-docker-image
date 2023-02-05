data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_s3_bucket" "codepipeline_artifacts_s3_bucket" {
  bucket = var.codepipeline_artifacts_s3_bucket_name
}

resource "aws_codecommit_repository" "hugo_repo" {
  repository_name = var.codecommit_repo_name
  description     = "The AWS CodeCommit repository where the code to build the container will be stored."
  default_branch  = var.codecommit_repo_default_branch_name
}

resource "aws_ecr_repository" "hugo_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_codebuild_project" "hugo_imagebuild_project" {
  name          = var.codebuild_project_name
  description   = "AWS CodeBuild Project to build the container imager for hugo"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_service_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_REGION"
      value = local.region_name
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = local.account_id
    }

    environment_variable {
      name  = "ECR_REPO_NAME"
      value = aws_ecr_repository.hugo_repo.name
    }
    environment_variable {
      name  = "IMAGE_TAG_PREFIX"
      value = var.image_tag_prefix
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.codebuild_cloudwatch_logs_group_name
      stream_name = var.codebuild_cloudwatch_logs_stream_name
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.hugo_repo.clone_url_http
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  tags = {
    Environment = var.env
  }
}

# create a KMS customer managed key that will be used to encrypt the codepipeline artifacts
resource "aws_kms_key" "hugo_kms_key" {
  description = "KMS key used by hugo CodePipeline pipeline"
}

resource "aws_codepipeline" "hugo_imagebuild_pipeline" {
  name     = var.codepipeline_pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = data.aws_s3_bucket.codepipeline_artifacts_s3_bucket.id
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.hugo_kms_key.id
      type = "KMS"
    }
  }
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = aws_codecommit_repository.hugo_repo.id
        BranchName           = "main"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.hugo_imagebuild_project.name
      }
    }
  }
}

resource "aws_cloudwatch_event_rule" "trigger_image_build" {
  name        = var.cloudwatch_events_rule_name
  description = "Trigger the CodePipeline pipline to build the image for hugo whenever a new push is made to hugo CodeCommit repository"

  event_pattern = <<PATTERN
{
  "source": [ 
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "resources": [ 
    "${aws_codecommit_repository.hugo_repo.arn}"
  ],
  "detail": {
    "event": [
      "referenceCreated",
      "referenceUpdated"
    ],
    "referenceType": [
        "branch"
    ],
    "referenceName": [
      "main"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "trigger_image_build" {
  target_id = "trigger_hugo_image_build"
  rule      = aws_cloudwatch_event_rule.trigger_image_build.id
  arn       = aws_codepipeline.hugo_imagebuild_pipeline.arn

  role_arn = aws_iam_role.cloudwatch_events_role.arn
}