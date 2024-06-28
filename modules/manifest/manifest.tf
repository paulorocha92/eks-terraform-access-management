resource "null_resource" "deploy-yaml" {

  provisioner "local-exec" {
      command = "kubectl apply -f ${path.module}/rbac.yaml"
  }

}
