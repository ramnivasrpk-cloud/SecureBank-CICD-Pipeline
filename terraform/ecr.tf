resource "aws_ecr_repository" "account_service" {
  name = "securebank/account-service"
}

resource "aws_ecr_repository" "transaction_service" {
  name = "securebank/transaction-service"
}

resource "aws_ecr_repository" "auth_service" {
  name = "securebank/auth-service"
}

resource "aws_ecr_repository" "notification_service" {
  name = "securebank/notification-service"
}
