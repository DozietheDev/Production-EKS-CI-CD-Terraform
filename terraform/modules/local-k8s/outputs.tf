output "service_name" {
  value = kubernetes_service.app_svc.metadata[0].name
}

output "ingress_name" {
  value = kubernetes_ingress.app_ingress.metadata[0].name
}
