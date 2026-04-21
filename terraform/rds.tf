resource "aws_db_instance" "securebank_db" {
  identifier           = "securebank-postgres"
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15.3"
  instance_class       = "db.t3.micro"
  username             = "bankadmin"
  password             = var.db_password
  publicly_accessible  = false
  skip_final_snapshot  = true

  tags = {
    Name = "securebank-db"
  }
}
