resource "aws_codepipeline_webhook" "webhook" {
  name            = "${var.app_name}-${var.environment_name}-webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.pipeline.name
  tags            = local.common_tags

  authentication_configuration {
    secret_token = var.github_token
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/${var.environment_name}"
  }
}

resource "github_repository_webhook" "repository_webhook" {
  repository = var.app_name

  configuration {
    url          = aws_codepipeline_webhook.webhook.url
    content_type = "json"
    insecure_ssl = true
    secret       = var.github_token
  }

  events = ["push"]
}