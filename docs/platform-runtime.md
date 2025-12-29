# Platform Runtime Guide

This document explains how the platform runs **at runtime** once infrastructure and CI/CD are in place.
It is written for operators, platform engineers, and future-you at 02:00.

---

## Purpose

The runtime layer answers a simple question:

> Once the pipeline succeeds, what is actually running, how does traffic flow, and how do we operate it safely?

This document covers:
- What runs in AKS at runtime
- How workloads are deployed and accessed
- Identity, networking, and security at runtime
- How to debug and operate the platform

---

## High-Level Runtime Architecture

At runtime, the platform consists of:

- AKS clusters per environment (dev / test / prod)
- Namespace-per-environment isolation
- Helm-managed workloads deployed via CI
- Azure Workload Identity for pod-to-Azure access
- NGINX Ingress Controller for north–south traffic
- NetworkPolicies enforcing default-deny networking

CI/CD is responsible for **deployment**.
AKS is responsible for **execution**.

---

## Environments & Namespaces

Each environment maps to a dedicated cluster and namespace:

| Environment | AKS Cluster          | Namespace |
|------------|----------------------|-----------|
| dev        | aks-kingsila-dev     | dev       |
| test       | aks-kingsila-test    | test      |
| prod       | aks-kingsila-prod    | prod      |

Namespaces are created automatically by the deployment pipeline if missing.

---

## Workload Deployment Model

### Helm as the Runtime Contract

All application workloads:

- Are defined as Helm charts
- Are rendered in CI (`helm template`)
- Are applied using **AKS Run Command**

This ensures:
- Deterministic manifests
- No manual `kubectl apply`
- No kubeconfig credentials in CI

The **golden-app** chart is the reference implementation.

---

## Service Exposure

### ClusterIP Services

Each workload exposes a ClusterIP Service:

- Stable DNS inside the cluster
- Selector-based routing to pods
