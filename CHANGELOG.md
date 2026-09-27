# Changelog

## 2026-09-27 — Complete CALMOS visual identity

- Renamed user-facing application titles and metadata to CALMOS Survey.
- Added the supplied CALMOS favicon to public, administration, error, maintenance, and installer pages.
- Replaced remaining visible LimeSurvey marks with CALMOS assets.
- Applied the CALMOS purple palette and the requested daytime background colour `#E0A4ED`.
- Published the deployment as ECR image `calmos-survey:20260927-0323`.

## 2026-09-26 — CALMOS white-label deployment

- Added the CALMOS purple administration theme and supplied CALM logo.
- Added local Docker Compose deployment with MariaDB and automatic first-run bootstrap.
- Set standard password authentication as the displayed login method and blocklisted `TwoFactorAdminLogin`.
- Added administrator environment settings and local deployment guidance.
- Published the Linux ARM64 application image to Amazon ECR in `eu-west-2`: `956978958967.dkr.ecr.eu-west-2.amazonaws.com/calmos-survey:20260926-2211`.
- Replaced the production ECS web service at `https://surveys.calmos.io` after its new LimeSurvey target passed the ALB health check.
