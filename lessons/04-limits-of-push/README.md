# 🚪 Lesson 04 — Limits of push: the courier delivers… and LEAVES

**📍 You are here:** Lesson **04** of 12 — end of Part 1 · Previous: `lesson-03-cicd-push` · Next: `lesson-05-gitops-idea`

---

## 📦 What's in this branch

Lessons 01–03, **plus** the honest audit of the push model — the four gaps
that no amount of better pipeline fixes. This is the door into Part 2.

## 🧒 Explain like I'm 5

The courier robot 📮 is genuinely great. But watch what happens at **14:04**,
one minute after it delivered and drove away:

1. **Nobody is watching the room.** 🪑 A kid rearranges the chairs at 15:00
   (drift, lesson 02!). The courier? Already gone. It only comes back when
   someone mails new homework — maybe next Tuesday. The mess sits there
   unnoticed for days.
2. **The master key rides around town.** 🔑 The courier keeps the school's
   key in its van (CI secrets). If the van is robbed — the thief has your
   school key. The more powerful your pipeline, the scarier the van.
3. **Ten schools? Ten keys in the van.** 🏫🏫🏫 Every new cluster = another
   credential in CI, another pipeline config, another thing to rotate.
4. **The delivery log is in the mailroom, not the school.** 🧾 To answer
   "what's in Room 3B right now?", CI history shows what was *sent* —
   not what's *actually there* (see gap #1).

The insight of this whole course: **the fix is not a better courier.** It's a
guard who *lives in the school* and never stops comparing rooms to the plan.

## 🗺️ Diagram

```mermaid
flowchart LR
    ci["📮 pipeline run<br/>deploys at 14:03<br/>then EXITS"]
    cluster["🏫 cluster at 14:04+<br/>unguarded until the next push"]
    ci -->|"1 delivery moment - all good"| cluster
    cluster -.-> d1["2 🪑 drift creeps back<br/>nobody notices"]
    cluster -.-> d2["3 🔑 cluster keys live<br/>OUTSIDE, in CI"]
    cluster -.-> d3["4 🏫×10 clusters =<br/>10 keys, 10 configs"]
```

## ❓ What (the four gaps, precisely)

| # | Gap | Why the pipeline can't fix it |
|---|---|---|
| 1 | **Drift returns between pushes** | The pipeline runs at deploy *moments*; drift happens in the gaps |
| 2 | **Credentials outside the cluster** | Push needs a key that works from outside — that's the model |
| 3 | **Multi-cluster sprawl** | Each target needs its own key + config in CI |
| 4 | **No live source of truth** | CI logs say what was sent, not what's running now |

## 🤔 Why this matters

Each gap is annoying alone; together they're why "the pipeline is green but
prod is broken" is a meme. Gap #1 is lesson 02 all over again — automation
didn't kill drift, it just made deploys nicer. Gap #2 is the one security
teams lose sleep over. And gap #4 means that during an incident, you're
debugging *two* sources of truth that both might be lying.

## 🔧 How (feel gap #1 right now)

```bash
# the "pipeline" (you, lesson 03) deployed replicas: 2. Now, at "15:00":
kubectl -n gitops-school scale deployment hello-school --replicas=1

# question: what will tell you about this? answer: NOTHING.
# no alert, no status, no robot. It sits like this until the next push.
kubectl -n gitops-school get deploy hello-school     # 1/1 — silently degraded
```

Fix it back before Part 2: `kubectl apply -f k8s/`

## ⏭️ Next — Part 2 begins

A guard who lives inside, holds no outside key, and compares the rooms to the
plan **every few minutes, forever**. First, the idea with a name: **GitOps**.

```bash
git checkout lesson-05-gitops-idea
```
