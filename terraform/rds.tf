resource "aws_db_subnet_group" "banking" {
  name       = "securebank-db-subnet-group"
  subnet_ids = module.vpc.database_subnets
}
 
resource "aws_security_group" "rds" {
  name   = "securebank-rds-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }
}
 
resource "aws_db_instance" "banking_db" {
  identifier           = "securebank-postgres"
  engine               = "postgres"
  engine_version       = "15.3"
  instance_class       = "db.t3.medium"
  allocated_storage    = 100
  storage_encrypted    = true  # PCI-DSS compliance
  storage_type         = "gp3"
 
  db_name  = "bankingdb"
  username = "bankadmin"
  password = var.db_password  # Stored in Terraform vars / AWS Secrets Manager
 
  db_subnet_group_name   = aws_db_subnet_group.banking.name
  vpc_security_group_ids = [aws_security_group.rds.id]
 
  multi_az               = true   # High availability
  backup_retention_period = 30    # 30 days backup
  deletion_protection    = true
  skip_final_snapshot    = false
  final_snapshot_identifier = "securebank-final-snapshot"
 
  tags = { Name = "securebank-postgres" }
}
