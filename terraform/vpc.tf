module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
 
  name = "securebank-${var.environment}-vpc"
  cidr = "10.0.0.0/16"
 
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
 
  enable_nat_gateway     = true
  single_nat_gateway     = false  # one per AZ for HA in prod
  enable_dns_hostnames   = true
  enable_dns_support     = true
 
  # Tags required for EKS & ALB ingress controller
  public_subnet_tags = {
    "kubernetes.io/cluster/securebank-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                       = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/securebank-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"              = "1"
  }
}
