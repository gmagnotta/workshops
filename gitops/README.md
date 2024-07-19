# GitOps

This lab is used to demonstrate on how to install and use OpenShift GitOps.

## Resources

https://docs.openshift.com/gitops/1.13/installing_gitops/installing-openshift-gitops.html#installing-gitops-operator-using-cli_installing-openshift-gitops

## Quick things

If after submitting an Application, ArgoCD can create a namespace but can't deploy into it, you need to label the namespace as:

`oc label namespace <your-namespace> argocd.argoproj.io/managed-by=openshift-gitops`

openshift-gitops is the namespace where argocd is installed (by default is openshift-gitops)

In alternative, you can create manually ahead a namespace with the label

`apiVersion: v1
kind: Namespace
metadata:
  name: your-namespace
  labels:
    argocd.argoproj.io/managed-by: openshift-gitops`

Another alternative is to submit an Application with the label for the namespace:

`apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: your-application
  namespace: openshift-gitops
spec:
  project: default
  source:
    path: overlay/dev
    repoURL: http://your-repo
    targetRevision: your-branch
  destination:
    server: https://kubernetes.default.svc
    namespace: your-namespace
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
    managedNamespaceMetadata:
      labels:
        argocd.argoproj.io/managed-by: openshift-gitops`

## Admin

admin password is present in openshift-gitops namespace, in the openshift-gitops-cluster secret

## Configure users

Configure users as: https://docs.openshift.com/gitops/1.13/accesscontrol_usermanagement/configuring-argo-cd-rbac.html