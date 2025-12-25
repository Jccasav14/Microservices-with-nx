terraform {
  required_providers { aws = { source="hashicorp/aws", version="~> 5.0" } }
}

resource "aws_ecr_repository" "repos" {
  for_each = toset(var.repo_names)
  name     = each.value

  image_scanning_configuration { scan_on_push = true }

  tags = merge(var.tags, { Name = each.value })
}

output "repo_urls" {
  value = { for k, r in aws_ecr_repository.repos : k => r.repository_url }
}
