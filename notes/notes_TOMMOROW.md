NEXT SESSION
- Helm chart now renders cleanly
- observability + workloadIdentity guards fixed
- Need to:
  1) Add observability values to values-test.yaml
  2) Re-run Helm pipeline
  3) Fix ImagePullBackOff (describe pod → Events)
  4) Verify App Insights Live Metrics
