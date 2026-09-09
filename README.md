# 🤖 Learn Deployment the School Way — without ArgoCD vs with ArgoCD

The sister course to [learn-kubernetes-school](https://github.com/BaluRaut/learn-kubernetes-school):
that one teaches you **what runs your app** — this one teaches you **what deploys it and keeps it
honest**. You'll deploy the same tiny demo app ([k8s/](k8s/)) three ways — **by hand**, **with a
CI/CD push pipeline**, and **with ArgoCD (GitOps pull)** — and feel exactly why each step up exists.

🌐 **Interactive site:** **<https://baluraut.github.io/learn-argocd-school/>** — lesson cards +
every lesson as a numbered box-and-arrow diagram.

> 🎒 **Prerequisite:** lessons 01–11 of
> [learn-kubernetes-school](https://github.com/BaluRaut/learn-kubernetes-school) (pods,
> deployments, services, rollouts). If those words are comfortable, you're ready.

## 🎓 The 12 lessons

Each numbered branch adds ONE lesson folder (`lessons/NN-topic/README.md`) with an
explain-like-I'm-5 story, a school analogy, a diagram, **What / Why / How**, and hands-on
commands. Branches are **sequential** — branch 07 contains lessons 01–07.

```bash
git checkout lesson-01-deploy-by-hand   # read lessons/01-deploy-by-hand/README.md, then...
git checkout lesson-02-drift-problem    # ...keep going, one branch at a time
```

### Part 1 — deploying WITHOUT ArgoCD

| # | Branch | You learn | Analogy |
|---|---|---|---|
| 01 | `lesson-01-deploy-by-hand` | kubectl apply by hand — and why it doesn't scale | Carrying homework to school yourself 🎒 |
| 02 | `lesson-02-drift-problem` | Configuration drift & snowflake clusters | No master seating chart 🪑❓ |
| 03 | `lesson-03-cicd-push` | A CI/CD pipeline that deploys for you (push style) | The courier robot 📮 |
| 04 | `lesson-04-limits-of-push` | What push pipelines still can't fix | The courier delivers… and leaves 🚪 |

### Part 2 — GitOps with ArgoCD

| # | Branch | You learn | Analogy |
|---|---|---|---|
| 05 | `lesson-05-gitops-idea` | Git as the single source of truth | The master plan book 📖 |
| 06 | `lesson-06-install-argocd` | Installing ArgoCD + UI tour | Hiring the caretaker robot 🤖 |
| 07 | `lesson-07-first-application` | The Application resource | One page of the plan book 📄 |
| 08 | `lesson-08-sync-policies` | Manual vs auto sync, prune, selfHeal | House rules for the robot 📏 |
| 09 | `lesson-09-self-heal-drift` | Drift detection & self-heal, live | Chairs moved → chairs put back 🪑↩️ |
| 10 | `lesson-10-rollback-history` | Rollback = git revert; audit for free | Flip to yesterday's page ⏪ |
| 11 | `lesson-11-helm-kustomize-envs` | Helm, Kustomize, dev/stage/prod, app-of-apps | Fill-in-the-blank recipe books 📚 |
| 12 | `lesson-12-secrets-and-compare` | Secrets in GitOps + the final scorecard | Never glue the key into the book 🔑 |

## 📦 What's in this repo (main branch)

```
learn-argocd-school/
├── k8s/                     # the demo app: namespace + deployment + service
│                            #   (real public image — deployable as-is, no placeholders)
├── argocd/application.yaml  # the "plan book page" that deploys k8s/ via ArgoCD
└── docs/                    # the GitHub Pages site (home + lesson diagrams)
```

Everything runs on a **local cluster** (Docker Desktop's Kubernetes, minikube, or kind) —
zero cloud cost.

## 🚀 Quickest possible taste (5 min)

```bash
# hand-deploy the demo app (lesson 01 does this properly):
kubectl apply -f k8s/
kubectl -n gitops-school get pods

# ...and by lesson 07 the same app deploys itself from git via ArgoCD:
kubectl apply -f argocd/application.yaml
```
