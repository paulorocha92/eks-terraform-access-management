resource "aws_iam_group" "group" {
  for_each              = local.entity
  name                  = "${each.key}-${var.cluster_name}-eks-access-group"
  
}

resource "aws_iam_group_policy_attachment" "policy_attach" {

  for_each   = aws_iam_policy.policy
  policy_arn = each.value["arn"]
  group      = aws_iam_group.group[each.key].name

} 