# CALMOS Survey — local deployment

This is a CALMOS white-label deployment of LimeSurvey. The CALM mark and purple visual system are provided by the `CALMOS` admin theme.

## Run locally

1. Optionally copy `.env.example` to `.env` and set unique passwords.
2. Start the services with `docker compose up --build`.
3. Open `http://localhost:8090/admin`. On its first run, the container creates the initial administrator from `CALMOS_ADMIN_*` values. The defaults are intended only for local smoke testing; set unique values in `.env` before any shared use.
4. Sign in with that username and password. Add further survey authors under **Configuration → Users and groups → Manage users**.

## Authentication policy

Username/password authentication (`Authdb`) is the displayed login mechanism. Two-factor admin login is blocked through `corePluginBlacklist`, so users created in this deployment are not prompted for TFA. Plugin upload is also disabled to prevent a later local upload from changing that policy accidentally.

## Before AWS

Use a managed MariaDB/RDS instance, set unique secrets through AWS Secrets Manager or task secrets, terminate TLS at an ALB/CloudFront layer, and back up both the database and the `upload/` directory. Do not reuse the local `.env` example credentials.
