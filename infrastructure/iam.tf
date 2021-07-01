/* CodeBuild */
resource "aws_iam_role" "codebuild_role" {
  name               = "CodeBuildRole-${var.app_name}-${var.environment_name}"
  assume_role_policy = file("${path.module}/iam/CodeBuildTrustPolicy.json")
  tags               = local.common_tags

  force_detach_policies = true

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "CodeBuildPolicy-${var.app_name}-${var.environment_name}"
  role = aws_iam_role.codebuild_role.id
  policy = templatefile("${path.module}/iam/CodeBuildPolicy.json", {
    app_name                = var.app_name
    aws_region              = var.aws_region
    account_id              = data.aws_caller_identity.current.account_id
    codepipeline_bucket_arn = data.aws_s3_bucket.codepipeline_bucket.arn
    lambda_bucket           = module.base.lambda_bucket
    subnet_ids              = tolist(module.base.private_subnet_ids)
    secrets_name            = local.secrets_name
  })

  lifecycle {
    create_before_destroy = false
  }
}

/* CodePipeline */
resource "aws_iam_role" "codepipeline_role" {
  name               = "CodePipelineRole-${var.app_name}-${var.environment_name}"
  assume_role_policy = file("${path.module}/iam/CodePipelineTrustPolicy.json")
  tags               = local.common_tags

  force_detach_policies = true

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "CodePipelinePolicy-${var.app_name}-${var.environment_name}"
  role   = aws_iam_role.codepipeline_role.id
  policy = file("${path.module}/iam/CodePipelinePolicy.json")

  lifecycle {
    create_before_destroy = false
  }
}

/* Lambda */
resource "aws_iam_role" "lambda_execution_role" {
  name               = "LambdaExecutionRole-${var.app_name}-${var.environment_name}"
  assume_role_policy = file("${path.module}/iam/LambdaExecutionTrustPolicy.json")
  tags               = local.common_tags

  force_detach_policies = true

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy" "lambda_execution_policy" {
  name = "LambdaExecutionPolicy-${var.app_name}-${var.environment_name}"
  role = aws_iam_role.lambda_execution_role.id
  policy = templatefile("${path.module}/iam/LambdaExecutionPolicy.json", {
    app_name   = var.app_name
    aws_region = var.aws_region
    account_id = data.aws_caller_identity.current.account_id
  })

  lifecycle {
    create_before_destroy = false
  }
}

/* CloudWatch 
resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = var.app_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
  lifecycle {
    create_before_destroy = false
  }
}*/

/* API Gateway */
resource "aws_iam_policy" "api_gateway_policy" {
  name   = "APIGatewayPolicy-${var.app_name}-${var.environment_name}"
  policy = file("${path.module}/iam/APIGatewayPolicy.json")

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "attach_api_gateway_policy_to_lambda" {
  policy_arn = aws_iam_policy.api_gateway_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

/* S3 */
resource "aws_iam_policy" "s3_policy" {
  name = "S3Policy-${var.app_name}-${var.environment_name}"
  policy = templatefile("${path.module}/iam/S3Policy.json", {
    app_name = var.app_name
  })

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_lambda" {
  policy_arn = aws_iam_policy.s3_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

/* SecretsManager */
resource "aws_iam_policy" "secrets_manager_policy" {
  name = "SecretsManagerPolicy-${var.app_name}-${var.environment_name}"
  policy = templatefile("${path.module}/iam/SecretsManagerPolicy.json", {
    aws_region   = var.aws_region
    account_id   = data.aws_caller_identity.current.id
    app_name     = var.app_name
    secrets_name = local.secrets_name
  })

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "attach_secrets_manager_policy_to_lambda" {
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

/* SNS */
resource "aws_iam_policy" "sns_policy" {
  name = "SNSPolicy-${var.app_name}-${var.environment_name}"
  policy = templatefile("${path.module}/iam/SNSPolicy.json", {
    aws_region = var.aws_region
    account_id = data.aws_caller_identity.current.id
    app_name   = var.app_name
  })

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "attach_sns_policy_to_lambda" {
  policy_arn = aws_iam_policy.sns_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

/* SQS */
resource "aws_iam_policy" "sqs_policy" {
  name = "SQSPolicy-${var.app_name}-${var.environment_name}"
  policy = templatefile("${path.module}/iam/SQSPolicy.json", {
    aws_region = var.aws_region
    account_id = data.aws_caller_identity.current.id
    app_name   = var.app_name
  })

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "attach_sqs_policy_to_lambda" {
  policy_arn = aws_iam_policy.sqs_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}