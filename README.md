# Veracode IaC/Container Scan — Sample Project

A minimal repo with intentional misconfigurations so you can confirm your
Veracode IaC/Container/Secrets scan is running *and* actually publishing
results to the Veracode Platform.

## What's in here

- `terraform/main.tf` — open security group (SSH from 0.0.0.0/0), public S3
  bucket, unencrypted EBS volume, wildcard IAM policy, hardcoded password.
- `Dockerfile` — old base image tag, no non-root `USER`, hardcoded secret in
  `ENV`.
- `veracode.yml` — Repository Scanning config with `analysis_on_platform: true`
  set on the `veracode_iac_secrets_scan` block (this was the missing piece
  from your original file).
- `.github/workflows/veracode-iac-scan.yml` — optional GitHub Actions
  alternative using the `veracode/container_iac_secrets_scanning` action,
  in case you're not using the Veracode GitHub App / Repository Scanning.

> All "secrets" here are dummy placeholder strings, not real credentials —
> safe to commit for scan testing.

## Option A: Veracode Repository Scanning (GitHub App)

1. Install the Veracode GitHub App on this repo (Veracode Platform →
   Repos/Integrations → GitHub).
2. Push this repo as-is — the app reads `veracode.yml` at the root
   automatically, no workflow file needed.
3. Open a PR or push to a matching branch to trigger `veracode_iac_secrets_scan`.
4. Check the Veracode Platform under the application profile matching this
   repo's name — you should see IaC findings for the Terraform misconfigs.

## Option B: GitHub Actions

1. Add `VID` and `VKEY` as repo secrets (Settings → Secrets and variables →
   Actions).
2. Push this repo — the workflow in `.github/workflows/veracode-iac-scan.yml`
   runs on push/PR to `main` and scans the `terraform/` directory.
3. Results post as a PR comment and (with `analysis_on_platform: true` in
   `veracode.yml`, if you're combining both approaches) to the platform.

## Sanity check

If findings show up in your CI logs / PR comment but never in the Veracode
Platform UI, re-check `analysis_on_platform: true` is present in the exact
scan block you're using, and that you're looking at the correct application
profile (should match the repo name) under the IaC / Container results tab,
not the SAST or SCA tab.
