#!/bin/bash
task ansible:deps
task ansible:playbook:ubuntu-prepare
task ansible:playbook:k3s-install
wait 6000
kubectl --kubeconfig=./provision/kubeconfig create namespace flux-system --dry-run=client -o yaml | kubectl --kubeconfig=./provision/kubeconfig apply -f -
source .config.env
gpg --export-secret-keys --armor "${BOOTSTRAP_FLUX_KEY_FP}" | kubectl --kubeconfig=./provision/kubeconfig create secret generic sops-gpg --namespace=flux-system --from-file=sops.asc=/dev/stdin
git add -A
git commit -m "Reinitialize Commit - Part 1"
git push
kubectl --kubeconfig=./provision/kubeconfig apply --kustomize=./cluster/base/flux-system
kubectl --kubeconfig=./provision/kubeconfig apply --kustomize=./cluster/base/flux-system
wait 3000
git add -A
git commit -m "Reinitialize Commit - Part 2"
git push
exit 0