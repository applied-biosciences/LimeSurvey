#!/bin/sh
set -eu

if [ "${1:-}" = "apache2-foreground" ]; then
  : "${CALMOS_ADMIN_USER:=calmos-admin}"
  : "${CALMOS_ADMIN_PASSWORD:=calmos-local-only}"
  : "${CALMOS_ADMIN_NAME:=CALMOS Administrator}"
  : "${CALMOS_ADMIN_EMAIL:=admin@calmos.local}"

  until php -r '
    $pdo = new PDO(
      "mysql:host=" . (getenv("CALMOS_DB_HOST") ?: "db") . ";port=" . (getenv("CALMOS_DB_PORT") ?: "3306"),
      getenv("CALMOS_DB_USER") ?: "calmos",
      getenv("CALMOS_DB_PASSWORD") ?: "calmos-local-only"
    );
    exit(0);
  '; do
    echo "Waiting for CALMOS database..."
    sleep 2
  done

  if ! php -r '
    $pdo = new PDO(
      "mysql:host=" . (getenv("CALMOS_DB_HOST") ?: "db") . ";port=" . (getenv("CALMOS_DB_PORT") ?: "3306") . ";dbname=" . (getenv("CALMOS_DB_NAME") ?: "calmos_survey"),
      getenv("CALMOS_DB_USER") ?: "calmos",
      getenv("CALMOS_DB_PASSWORD") ?: "calmos-local-only"
    );
    $q = $pdo->query("SHOW TABLES LIKE \"calmos_settings_global\"");
    exit($q && $q->fetch() ? 0 : 1);
  '; then
    echo "Initialising CALMOS Survey database..."
    DBENGINE=InnoDB php application/commands/console.php install "$CALMOS_ADMIN_USER" "$CALMOS_ADMIN_PASSWORD" "$CALMOS_ADMIN_NAME" "$CALMOS_ADMIN_EMAIL"
  fi

  # The upstream seed defaults to Sea_Green; make the CALMOS theme durable across restarts.
  php -r '
    $pdo = new PDO(
      "mysql:host=" . (getenv("CALMOS_DB_HOST") ?: "db") . ";port=" . (getenv("CALMOS_DB_PORT") ?: "3306") . ";dbname=" . (getenv("CALMOS_DB_NAME") ?: "calmos_survey"),
      getenv("CALMOS_DB_USER") ?: "calmos",
      getenv("CALMOS_DB_PASSWORD") ?: "calmos-local-only"
    );
    $statement = $pdo->prepare("UPDATE calmos_settings_global SET stg_value = ? WHERE stg_name = ?");
    $statement->execute(["CALMOS", "admintheme"]);
  '

  # Keep the explicitly configured bootstrap administrator usable after restores.
  php -r '
    $pdo = new PDO(
      "mysql:host=" . (getenv("CALMOS_DB_HOST") ?: "db") . ";port=" . (getenv("CALMOS_DB_PORT") ?: "3306") . ";dbname=" . (getenv("CALMOS_DB_NAME") ?: "calmos_survey"),
      getenv("CALMOS_DB_USER") ?: "calmos",
      getenv("CALMOS_DB_PASSWORD") ?: "calmos-local-only"
    );
    $user = getenv("CALMOS_ADMIN_USER") ?: "calmos-admin";
    $password = getenv("CALMOS_ADMIN_PASSWORD") ?: "calmos-local-only";
    $check = $pdo->prepare("SELECT uid FROM calmos_users WHERE users_name = ? LIMIT 1");
    $check->execute([$user]);
    $uid = $check->fetchColumn();
    $hash = password_hash($password, PASSWORD_DEFAULT);
    if ($uid) {
      $statement = $pdo->prepare("UPDATE calmos_users SET password = ?, email = ?, full_name = ? WHERE uid = ?");
      $statement->execute([$hash, getenv("CALMOS_ADMIN_EMAIL") ?: $user, getenv("CALMOS_ADMIN_NAME") ?: "CALMOS Administrator", $uid]);
    }
  '
fi

exec docker-php-entrypoint "$@"
