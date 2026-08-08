#!/usr/bin/env bash
# QloApps backup: dump MariaDB + archive media and generated secrets.
# Usage: ./scripts/backup.sh [backup_dir]   (default: ./backups)
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  COMPOSE=(docker compose)
elif command -v podman-compose >/dev/null 2>&1; then
  COMPOSE=(podman-compose)
else
  echo "Docker Compose or podman-compose is required." >&2
  exit 1
fi

BACKUP_DIR="${1:-./backups}"
STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo ">> Dumping database (qloapps)..."
"${COMPOSE[@]}" exec -T db sh -c \
  'exec mariadb-dump --single-transaction --routines --triggers -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" "$MARIADB_DATABASE"' \
  > "$BACKUP_DIR/db-$STAMP.sql"

echo ">> Archiving images, uploads and downloads..."
"${COMPOSE[@]}" exec -T web tar -C /var/www/html \
  -czf - img upload download > "$BACKUP_DIR/media-$STAMP.tar.gz"

echo ">> Archiving generated cookie keys..."
"${COMPOSE[@]}" exec -T web tar -C /var/lib/qloapps-secrets \
  -czf - . > "$BACKUP_DIR/secrets-$STAMP.tar.gz"

echo ">> Backups written to $BACKUP_DIR:"
ls -lh "$BACKUP_DIR" | tail -n +2
