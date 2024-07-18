# GitOps

This lab is used to demonstrate on how to install and use OpenShift GitOps.

## Resources

https://docs.openshift.com/gitops/1.13/installing_gitops/installing-openshift-gitops.html#installing-gitops-operator-using-cli_installing-openshift-gitops

## Quick things

If after submitting an Application, ArgoCD can create a namespace but can't deploy into it, you need to label the namespace as:

`oc label namespace <your-namespace> argocd.argoproj.io/managed-by=openshift-gitops`

openshift-gitops is the namespace where argocd is installed (by default is openshift-gitops)

In alternative, you can create a namespace already with the label

`apiVersion: v1
kind: Namespace
metadata:
  name: your-namespace
  labels:
    argocd.argoproj.io/managed-by: openshift-gitops`
