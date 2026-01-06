resource "kubernetes_manifest" "argocd_app" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "hello-app"
      "namespace" = "argocd"
      "finalizers" = [
        "resources-finalizer.argocd.argoproj.io"  # To delete k8s resources upon application deletion
      ]
    }
    "spec" = {
      "project" = "default"
      "source" = {
        "repoURL"        = "https://github.com/${var.gh_repo}.git"
        "targetRevision" = "HEAD"
        "chart"          = "helm"
        "helm"           = {
          "releaseName" = "hello-app"
          "valueFiles"  = [
            "helm_values.yaml"
          ]
        }
      }
      "destination" = {
        "server"    = "https://kubernetes.default.svc"
        "namespace" = "hello-app"
      }
      "syncPolicy" = {
        "automated" = {
          "prune"    = true
          "selfHeal" = true
        }
        "syncOptions" = [
          "CreateNamespace=true"
        ]
      }
    }
  }

  depends_on = [
    helm_release.argocd,
    null_resource.run_first_build
  ] 
}