data "aws_s3_bucket" "codepipeline_bucket" {
  bucket = module.base.codepipeline_bucket
}

/* CodeBuild */
resource "aws_codebuild_project" "codebuild" {
  name         = "${var.app_name}-${var.environment_name}"
  service_role = aws_iam_role.codebuild_role.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false

    environment_variable {
      name  = "APP_NAME"
      value = var.app_name
    }

    environment_variable {
      name  = "APP_PREFIX"
      value = var.app_prefix
    }

    environment_variable {
      name  = "SECRETS_NAME"
      value = local.secrets_name
    }

    environment_variable {
      name  = "ENVIRONMENT_NAME"
      value = var.environment_name
    }

    environment_variable {
      name  = "ACCOUNT_ID"
      value = data.aws_caller_identity.current.id
    }

    /* Lambda */
    environment_variable {
      name  = "LAMBDA_RUNTIME"
      value = var.lambda_runtime
    }

    environment_variable {
      name  = "LAMBDA_DEPLOYMENT_BUCKET"
      value = module.base.lambda_bucket
    }

    environment_variable {
      name  = "LAMBDA_HANDLER"
      value = var.lambda_handler
    }

    environment_variable {
      name  = "LAMBDA_MEMORY_SIZE"
      value = var.lambda_memory_size
    }

    environment_variable {
      name  = "LAMBDA_TIMEOUT"
      value = var.lambda_timeout
    }

    /* Network */
    environment_variable {
      name  = "LAMBDA_SECURITY_GROUP_ID"
      value = tolist(module.base.lambda_security_group_ids)[0]
    }

    dynamic "environment_variable" {
      for_each = tolist(module.base.lambda_subnet_ids)

      content {
        name  = "SUBNET_ID_${index(tolist(module.base.lambda_subnet_ids), environment_variable.value)}"
        value = environment_variable.value
      }
    }

    /* SQS 
    dynamic "environment_variable" {
      for_each = aws_sqs_queue.queue
      content {
        name  = "SQS_QUEUE_ARN_${index(keys(aws_sqs_queue.queue), environment_variable.key)}"
        value = environment_variable.value.arn
      }
    }*/

    /* Secret Manager */
    environment_variable {
      name  = "SECRET_NAME"
      value = "${var.app_name}-${var.environment_name}"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  vpc_config {
    vpc_id             = module.base.vpc_id
    subnets            = module.base.private_subnet_ids
    security_group_ids = module.base.default_private_security_group_ids
  }
}

/* CodePipeline */
resource "aws_codepipeline" "pipeline" {
  name     = "${var.app_name}-${var.environment_name}"
  role_arn = aws_iam_role.codepipeline_role.arn
  tags     = local.common_tags

  artifact_store {
    location = module.base.codepipeline_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_artifact"]
      configuration = {
        Owner                = module.base.github_owner
        Repo                 = var.app_name
        Branch               = var.environment_name
        OAuthToken           = var.github_token
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_artifact"]
      configuration = {
        ProjectName = aws_codebuild_project.codebuild.name
      }
    }
  }

  lifecycle {
    ignore_changes = [
      stage[0].action[0].configuration.OAuthToken
    ]
  }
}