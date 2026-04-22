locals {
  services = ["account-service", "transaction-service", "auth-service", "notification-service"]
}
 
resource "aws_ecr_repository" "services" {
  for_each             = toset(local.services)
  name                 = "securebank/${each.key}"
  image_tag_mutability = "MUTABLE"
 
  image_scanning_configuration {
    scan_on_push = true  # Auto-scan every pushed image
  }
 
  encryption_configuration {
    encryption_type = "AES256"
  }
}
 
# Lifecycle policy: keep last 10 images, delete older ones
resource "aws_ecr_lifecycle_policy" "cleanup" {
  for_each   = aws_ecr_repository.services
  repository = each.value.name
 
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = { type = "expire" }
    }]
  })
}

