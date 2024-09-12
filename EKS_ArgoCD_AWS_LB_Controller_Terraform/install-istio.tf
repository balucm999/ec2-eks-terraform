# Ensure kubeconfig is updated
resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region us-west-1 --name k8s-cluster"
  }

  depends_on = [
    module.eks
  ]
}

# Ensure install-istio.sh is executable
resource "null_resource" "ensure_istio_script_executable" {
  provisioner "local-exec" {
    command = "chmod +x ./install-istio.sh"
  }
}

# Run install-istio.sh after kubeconfig is updated
resource "null_resource" "run_istio_script" {
  provisioner "local-exec" {
    command = "./install-istio.sh"
  }

  depends_on = [
    null_resource.update_kubeconfig,
    null_resource.ensure_istio_script_executable
  ]
}

# Outputs and other configurations
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
