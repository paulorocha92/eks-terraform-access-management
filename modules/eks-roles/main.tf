data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "policy" {
  for_each    = local.entity
  name        = "${each.key}-${var.cluster_name}"
  path        = "/"
  description = "IAM policy to access EKS cluster as ${each.key}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
         {
            "Effect": "Allow",
            "Action": [
              "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${each.key}-${var.cluster_name}"
        }
    ]
}
EOF
}

resource "aws_iam_role" "role" {
  for_each              = local.entity
  name                  = "${each.key}-${var.cluster_name}"
  path                  = "/"
  description           = "IAM role to provide access to EKS ${each.key} users"
  force_detach_policies = false
  tags                  = var.tags
  depends_on            = [aws_iam_policy.policy]
  assume_role_policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each   = aws_iam_policy.policy
  role       = each.value["name"]
  policy_arn = each.value["arn"]

  depends_on = [
    aws_iam_policy.policy,
    aws_iam_role.role
  ]
}

resource "null_resource" "apply_cluster_roles" {

  provisioner "local-exec" {
    command = <<-EOT
        cluster_name="${var.cluster_name}"

        while true; do
            cluster_status=$(aws eks describe-cluster --name "$cluster_name" --query 'cluster.status' --output text)

            if [ "$cluster_status" = "ACTIVE" ]; then
                echo "Cluster is now ACTIVE, applying manifest..."
                kubectl apply -f ../manifest/rbac.yaml
                break  # Saímos do loop quando o status for ACTIVE e o apply for executado
            else
                echo "Waiting for the cluster to be ACTIVE..."
                sleep 10  # Espera por 10 segundos antes de verificar novamente
            fi
        done
    EOT
  }
}