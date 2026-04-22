module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"
 
  cluster_name    = "securebank-eks-cluster"
  cluster_version = "1.28"
 
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true
 
  eks_managed_node_groups = {
    banking_nodes = {
      instance_types = ["t3.large"]
      min_size       = 3
      max_size       = 8
      desired_size   = 3
      disk_size      = 50
      labels = {
        role = "banking-app"
      }
      taints = []
    }
  }
 
  # Enable IRSA (IAM Roles for Service Accounts)
  enable_irsa = true
 
  tags = { Name = "securebank-eks-cluster" }
}
 
# IAM role for Jenkins to access EKS
resource "aws_iam_role_policy_attachment" "jenkins_eks" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
