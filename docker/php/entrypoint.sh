#!/usr/bin/env bash
set -euo pipefail

APP_DIR=/var/www/html
MEDIA_SEED_DIR=/usr/local/share/qloapps-media
SECRET_DIR=/var/lib/qloapps-secrets
KEY_FILE="$SECRET_DIR/cookie-keys.env"

: "${DB_HOST:=db}"
: "${DB_PORT:=3306}"
: "${DB_NAME:=qloapps}"
: "${DB_USER:=qloapps}"
: "${DB_PASSWD:=qloapps}"
: "${DB_PREFIX:=qlo_}"
: "${MYSQL_ENGINE:=InnoDB}"
: "${PS_VERSION:=1.6.1.23}"
: "${QLOAPPS_VERSION:=1.7.0.0}"
PS_CREATION_DATE="${PS_CREATION_DATE:-$(date +%Y-%m-%d)}"

mkdir -p \
    "$APP_DIR/img" \
    "$APP_DIR/upload" \
    "$APP_DIR/download" \
    "$APP_DIR/cache/smarty/compile" \
    "$APP_DIR/cache/smarty/cache" \
    "$APP_DIR/config/xml" \
    "$APP_DIR/var/logs" \
    "$APP_DIR/var/cache" \
    "$APP_DIR/var/sessions" \
    "$SECRET_DIR"

# Stale compiled templates can pin the previous theme/config; rebuild them.
rm -rf \
    "$APP_DIR/cache/smarty/compile"/* \
    "$APP_DIR/cache/smarty/cache"/*

# Add image-provided media to new volumes without overwriting user uploads.
cp -a -n "$MEDIA_SEED_DIR/img"/. "$APP_DIR/img"/
cp -a -n "$MEDIA_SEED_DIR/upload"/. "$APP_DIR/upload"/
cp -a -n "$MEDIA_SEED_DIR/download"/. "$APP_DIR/download"/

provided_keys=0
for key_name in COOKIE_KEY COOKIE_IV NEW_COOKIE_KEY; do
    if [ -n "${!key_name:-}" ]; then
        provided_keys=$((provided_keys + 1))
    fi
done

if [ "$provided_keys" -ne 0 ] && [ "$provided_keys" -ne 3 ]; then
    echo "[qloapps] COOKIE_KEY, COOKIE_IV and NEW_COOKIE_KEY must be provided together." >&2
    exit 1
fi

if [ "$provided_keys" -eq 0 ] && [ -f "$KEY_FILE" ]; then
    # The file contains only generated alphanumeric values.
    # shellcheck disable=SC1090
    source "$KEY_FILE"
elif [ "$provided_keys" -eq 0 ]; then
    echo "[qloapps] generating persistent cookie keys"
    COOKIE_KEY="$(php -r 'echo bin2hex(random_bytes(28));')"
    COOKIE_IV="$(php -r 'echo bin2hex(random_bytes(8));')"
    NEW_COOKIE_KEY="$(php -r 'require "/var/www/html/tools/defuse/php-encryption/defuse-crypto.phar"; echo Defuse\Crypto\Key::createNewRandomKey()->saveToAsciiSafeString();')"
fi

# Validate the key the way the app does (Defuse checksum, not just shape):
# a malformed-but-regex-matching key would boot fine but fatal on first page view.
if ! php -r 'require "/var/www/html/tools/defuse/php-encryption/defuse-crypto.phar"; Defuse\Crypto\Key::loadFromAsciiSafeString($argv[1]);' "$NEW_COOKIE_KEY" 2>/dev/null; then
    if [ "$provided_keys" -eq 0 ]; then
        # Persisted key from a previous (buggy) boot: regenerate instead of crash-looping.
        echo "[qloapps] persisted NEW_COOKIE_KEY is not a valid Defuse key; regenerating cookie keys" >&2
        rm -f "$KEY_FILE"
        COOKIE_KEY="$(php -r 'echo bin2hex(random_bytes(28));')"
        COOKIE_IV="$(php -r 'echo bin2hex(random_bytes(8));')"
        NEW_COOKIE_KEY="$(php -r 'require "/var/www/html/tools/defuse/php-encryption/defuse-crypto.phar"; echo Defuse\Crypto\Key::createNewRandomKey()->saveToAsciiSafeString();')"
    else
        echo "[qloapps] NEW_COOKIE_KEY is not a valid Defuse key (expected 'def00000' + 128 hex chars)." >&2
        exit 1
    fi
fi

if [ ! -f "$KEY_FILE" ]; then
    umask 077
    printf 'COOKIE_KEY=%s\nCOOKIE_IV=%s\nNEW_COOKIE_KEY=%s\n' \
        "$COOKIE_KEY" "$COOKIE_IV" "$NEW_COOKIE_KEY" > "$KEY_FILE"
fi

export DB_HOST DB_PORT DB_NAME DB_USER DB_PASSWD DB_PREFIX MYSQL_ENGINE
export COOKIE_KEY COOKIE_IV NEW_COOKIE_KEY PS_CREATION_DATE PS_VERSION QLOAPPS_VERSION

php /usr/local/lib/qloapps/generate-settings.php
php /usr/local/lib/qloapps/configure-database.php

chown -R www-data:www-data \
    "$APP_DIR/cache" \
    "$APP_DIR/config/xml" \
    "$APP_DIR/var" \
    "$APP_DIR/log" \
    "$APP_DIR/img" \
    "$APP_DIR/upload" \
    "$APP_DIR/download"
chown root:www-data "$APP_DIR/config/settings.inc.php"
chmod 640 "$APP_DIR/config/settings.inc.php"

echo "[qloapps] ready. Starting Apache."
exec docker-php-entrypoint "$@"
