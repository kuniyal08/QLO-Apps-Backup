#!/bin/bash
# Start local QloApps dev environment (no sudo needed)
# Front: http://localhost:8080   Admin: http://localhost:8080/hotel-admin/
# Login: admin@example.com / admin123
set -e
ROOT="/home/user/QLO-Apps-Backup"
RUN_DIR="/tmp/opencode/mysql-run"
DATA_DIR="/tmp/opencode/mysql-data"
mkdir -p "$RUN_DIR"

if ! mariadb --socket="$RUN_DIR/mysql.sock" -uroot -e "SELECT 1" >/dev/null 2>&1; then
  echo "Starting MariaDB..."
  mariadbd --datadir="$DATA_DIR" --socket="$RUN_DIR/mysql.sock" --port=3307 \
    --bind-address=127.0.0.1 --pid-file="$RUN_DIR/mysqld.pid" \
    --skip-networking=0 --log-error="$RUN_DIR/error.log" &
  sleep 4
fi
echo "MariaDB OK"

if curl -s -o /dev/null http://localhost:8080/ ; then
  echo "PHP server already running on :8080"
else
  echo "Starting PHP server on :8080"
  (cd "$ROOT" && nohup php -S 0.0.0.0:8080 > "$RUN_DIR/php-server.log" 2>&1 &)
  sleep 2
fi
echo "Site:  http://localhost:8080/"
echo "Admin: http://localhost:8080/hotel-admin/"
