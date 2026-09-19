#!/usr/bin/env bash
# Is my machine ready for the ArgoCD school? Run: bash scripts/check-setup.sh
# Checks the tools, the kubectl context, node readiness and namespace permission.
ok=0; bad=0
pass() { printf '  ✅ %s\n' "$1"; ok=$((ok+1)); }
fail() { printf '  ❌ %s\n' "$1"; bad=$((bad+1)); }
opt()  { printf '  ➖ %s\n' "$1"; }

echo "🔧 Tools"
for t in git kubectl; do command -v "$t" >/dev/null 2>&1 && pass "$t: $(command -v "$t")" || fail "$t not found"; done
command -v docker >/dev/null 2>&1 && pass "docker (Docker Desktop / kind / k3d use it)" || opt "docker not found — fine with minikube's own driver"
command -v argocd  >/dev/null 2>&1 && pass "argocd CLI (optional, lesson 06)" || opt "argocd CLI not installed — optional; the UI is enough"
command -v kubeseal >/dev/null 2>&1 && pass "kubeseal (optional, lesson 12)" || opt "kubeseal not installed — optional until lesson 12"

echo "☸️  Cluster"
ctx=$(kubectl config current-context 2>/dev/null)
if [ -z "$ctx" ]; then
  fail "no kubectl context — start a local cluster: Docker Desktop (enable Kubernetes), 'minikube start', 'kind create cluster' or 'k3d cluster create'"
else
  pass "context: $ctx"
  case "$ctx" in *eks*|*gke*|*aks*|*arn:aws*) echo "  ⚠️  that looks like a CLOUD cluster — it bills while it runs; all 12 lessons work on a local one";; esac
  if kubectl get nodes --no-headers >/dev/null 2>&1; then
    notready=$(kubectl get nodes --no-headers 2>/dev/null | grep -vc ' Ready')
    total=$(kubectl get nodes --no-headers 2>/dev/null | wc -l | tr -d ' ')
    [ "$notready" -eq 0 ] && pass "$total node(s) Ready" || fail "$notready of $total node(s) not Ready"
  else
    fail "cannot reach the cluster (kubectl get nodes failed)"
  fi
  can=$(kubectl auth can-i create namespace 2>/dev/null)
  [ "$can" = "yes" ] && pass "can create namespaces (needed for gitops-school and argocd)" || fail "cannot create namespaces — use an admin context or a local cluster"
  kubectl get ns argocd >/dev/null 2>&1 && opt "namespace 'argocd' already exists (lesson 06 done?)"
fi

echo
[ "$bad" -eq 0 ] && echo "🎒 Ready. Start with: git checkout lesson-01-deploy-by-hand" || echo "🛠  Fix the ❌ items above, then run this again."
