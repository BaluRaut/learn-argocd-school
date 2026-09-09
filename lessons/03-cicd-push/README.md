# 📮 Lesson 03 — CI/CD push: the courier robot deploys for you

**📍 You are here:** Lesson **03** of 12 · Previous: `lesson-02-drift-problem` · Next: `lesson-04-limits-of-push`

---

## 📦 What's in this branch

Lessons 01–02, **plus** the first real fix: a **CI/CD pipeline** that tests,
builds and deploys on every push — the **push model**, where an outside system
shoves changes into the cluster.

## 🧒 Explain like I'm 5

The school got tired of kids hand-delivering homework, so it hired a
**courier robot** 📮. Now you just drop your homework in the mailbox
(`git push`) and the robot does the same steps, every single time:

1. **Checks it** ✅ — spelling and math (runs the tests). Bad homework never
   leaves the mailroom.
2. **Photocopies it** 🍱 — the official copy (builds the container image).
3. **Files the copy** 🗄️ — into the cabinet (pushes to the registry).
4. **Delivers it** 🚚 — drives to school, unlocks the door with the **master
   key it carries** 🔑, and puts everything in place (`kubectl apply`).

Huge upgrade! No more forgotten steps, no more "works on my machine", and
there's a delivery log in the mailroom. But keep an eye on that master key —
and on what happens *after* the robot drives away… (lesson 04 😈)

## 🗺️ Diagram

```mermaid
flowchart LR
    dev["🧑‍💻 dev<br/>git push"]
    subgraph ci["📮 the courier robot - CI/CD"]
        t["✅ test"] --> b["🍱 build image"] --> r["🗄️ registry"]
    end
    cluster["🏫 cluster<br/>kubectl apply from OUTSIDE<br/>using stored credentials 🔑"]
    dev -->|"1"| ci
    r -->|"3 PUSH deploy"| cluster
    t -.->|"2 bad code stops here"| dev
```

## ❓ What

- **CI** (Continuous Integration): every push is automatically tested & built.
- **CD** (Continuous Delivery/Deployment): the built artifact is automatically
  released. Together: nobody deploys by hand anymore.
- **Push model**: the pipeline holds **cluster credentials** (a kubeconfig or
  cloud keys stored as CI secrets) and pushes changes in from outside.
- This is exactly what the
  [Kubernetes course's CircleCI pipeline](https://github.com/BaluRaut/learn-kubernetes-school/blob/main/.circleci/config.yml)
  does: test → build → push to ECR → manual approval → `kubectl apply`.

## 🤔 Why

The pipeline fixes the *human* problems from lesson 01: forgotten steps,
skipped tests, single-person knowledge, no delivery record. Every deploy is
now traceable to a commit and repeatable. This alone is a massive, genuine
upgrade — most teams should get here before even thinking about ArgoCD.

## 🔧 How (a minimal example)

A push-style deploy job in GitHub Actions looks like this (illustrative —
don't commit real cluster credentials, use CI secrets):

```yaml
# .github/workflows/deploy.yml (example — the k8s course uses CircleCI, same idea)
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "$KUBECONFIG_DATA" | base64 -d > kubeconfig   # 🔑 the master key, stored in CI
        env: { KUBECONFIG_DATA: ${{ secrets.KUBECONFIG_DATA }} }
      - run: KUBECONFIG=kubeconfig kubectl apply -f k8s/        # push it in
      - run: KUBECONFIG=kubeconfig kubectl -n gitops-school rollout status deploy/hello-school
```

Note what just happened: **the cluster's key now lives outside the cluster**,
in the CI system's secret store. Remember that.

## 🧪 Try it (simulate the robot locally)

```bash
# play courier robot yourself — the exact steps a pipeline runs:
kubectl diff -f k8s/ || true                          # 1. what would change?
kubectl apply -f k8s/                                 # 2. deliver
kubectl -n gitops-school rollout status deploy/hello-school   # 3. confirm it landed

# the pipeline's superpower is that it NEVER does it differently.
# your superpower is that you now know each step it automates.
```

## ⏭️ Next

The courier is great — so why does Part 2 of this course exist? Because of
what the courier **can't** do. Lesson 04 counts the gaps.

```bash
git checkout lesson-04-limits-of-push
```
