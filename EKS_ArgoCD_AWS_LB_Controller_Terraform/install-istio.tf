# Ensure install-istio.sh is executable
resource "null_resource" "ensure_istio_script_executable" {
  provisioner "local-exec" {
    command = "chmod +x ./install-istio.sh"
  }
}
# Run install-istio.sh after EKS cluster is provisioned
resource "null_resource" "run_istio_script" {
  provisioner "local-exec" {
    command = "./install-istio.sh"
  }

  depends_on = [
    module.eks,
    null_resource.ensure_istio_script_executable
  ]
}

# Outputs and other configurations
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
