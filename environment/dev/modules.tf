module "eks-role" {
  source = "../../modules/eks-roles"
}

module "manifest" {
  source = "../../modules/manifest"
  depends_on = [module.eks-role]
}
