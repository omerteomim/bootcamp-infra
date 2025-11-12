resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "27.40.1"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set = [{
    name  = "server.service.type"
    value = "ClusterIP"
  },
  {
    name = "server.additionalScrapeConfigs[0].job_name"
    value = "chart-psychometric-backend-service"
  },
  {
    name = "server.persistentVolume.enabled"
    value = "false"
  },
  {
    name = "alertmanager.enabled"
    value = "false"
  },
  {
    name = "kubeStateMetrics.enabled"
    value = "false"
  },
  {
    name = "pushgateway.enabled"
    value = "false"
  },
  {
    name  = "server.resources.requests.cpu"
    value = "100m"
  },
  {
    name  = "server.resources.requests.memory"
    value = "128Mi"
  },
  {
    name  = "server.resources.limits.cpu"
    value = "500m"
  },
  {
    name  = "server.resources.limits.memory"
    value = "512Mi"
  },
  {
    name = "server.additionalScrapeConfigs[0].static_configs[0].targets[0]"
    value = "chart-psychometric-backend-service.psychometry-app.svc.cluster.local:5000"
  }]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "9.4.5"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
   values = [
    yamlencode({
      service = {
        type = "NodePort"
      }
      adminPassword = var.grafana_admin_password
      datasources = {
        "datasources.yaml" = {
          apiVersion = 1
          datasources = [
            {
              name      = "Prometheus"
              type      = "prometheus"
              access    = "proxy"
              url       = "http://prometheus-server.monitoring.svc.cluster.local"
              isDefault = true
              editable  = false
            }
          ]
        }
      }
      dashboardProviders = {
        "dashboardproviders.yaml" = {
          apiVersion = 1
          providers = [
            {
              name    = "default"
              orgId   = 1
              folder  = ""
              type    = "file"
              options = {
                path = "/var/lib/grafana/dashboards"
              }
            }
          ]
        }
      }
      dashboards = {
        default = {
          backend_metrics = {
            json = file("${path.module}/backend_metrics.json")
          }
        }
      }
    })
  ]

#   set =[{
#     name  = "service.type"
#     value = "LoadBalancer"
#   },
#   {
#     name = "datasources.datasources\\.yaml"
#     value = <<EOF
# apiVersion: 1
# datasources:
#   - name: Prometheus
#     type: prometheus
#     access: proxy
#     url: http://prometheus-server.monitoring.svc.cluster.local
#     isDefault: true
#     editable: false
# EOF
#   },
#   {
#     name = "dashboardProviders.dashboardproviders\\.yaml"
#     value = <<EOF
# apiVersion: 1
# providers:
#   - name: "Backend Metrics"
#     orgId: 1
#     folder: ""
#     type: file
#     options:
#         path: /var/lib/grafana/dashboards
#         folderFromFilesStructure: true
# EOF
#   },
#   {
#     name = "dashboards.files.backend_metrics"
#     value = file("${path.module}/backend_metrics.json")
#   }]
#   set_sensitive = [{
#     name  = "adminPassword"
#     value = var.grafana_admin_password
#   }]
  depends_on = [helm_release.prometheus]
}
