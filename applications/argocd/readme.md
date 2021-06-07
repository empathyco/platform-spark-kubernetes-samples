## Pre installation
Create k8s secrets with github and Google credentials

## Installation

`helm dependency update` to download official argo chart into `charts/`



`helm install argocd . -f values.yaml -f secrets.yaml`


## Disable Auth 
`kubectl patch deploy argocd-server -n argocd -p '[{"op": "add", "path": "/spec/template/spec/containers/0/command/-", "value": "--disable-auth"}]' --type json`