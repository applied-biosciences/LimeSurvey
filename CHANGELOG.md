# Changelog

## 2026-09-26 — CALMOS white-label deployment

- Added the CALMOS purple administration theme and supplied CALM logo.
- Added local Docker Compose deployment with MariaDB and automatic first-run bootstrap.
- Set standard password authentication as the displayed login method and blocklisted `TwoFactorAdminLogin`.
- Added administrator environment settings and local deployment guidance.
- Published the Linux ARM64 application image to Amazon ECR in `eu-west-2`: `956978958967.dkr.ecr.eu-west-2.amazonaws.com/calmos-survey:20260926-2211`.
