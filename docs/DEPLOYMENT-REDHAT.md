# QloApps Container Development and Rocky Linux Deployment

This project currently uses a two-service Compose stack:

- `web`: Apache 2.4 + PHP 8.3 + QloApps
- `db`: MariaDB 10.11 LTS

The current stack is intended for development and testing. It has been built
and verified with rootless Podman on Fedora. The Compose definition is also
compatible with Docker Compose, but Docker Engine is not available in this
workspace for direct verification.

## Why Apache

QloApps is based on PrestaShop 1.6. Apache keeps this development stack simple:

- One web container instead of separate nginx and PHP-FPM containers
- No nginx-to-PHP DNS/IP failures after container recreation
- No shared application-code volume
- Native support for PrestaShop-style `.htaccess` rewrites
- Application updates are deployed by rebuilding the image

## Docker and sudo

Docker Engine runs a root-owned daemon. Installing and starting it requires
root or `sudo`. Afterwards, either:

- Run Docker commands with `sudo`; or
- Add a user to the `docker` group.

Membership in the `docker` group is effectively root access because Docker can
mount and modify host files as root.

Podman is daemonless and supports rootless containers. Podman commands normally
do not require `sudo`, but installing Podman system packages still requires an
administrator.

### Docker Engine advantages

- Most widely documented Compose workflow
- Strong compatibility with third-party Docker images and CI systems
- Official Docker Compose plugin

### Docker Engine disadvantages

- Root daemon
- `docker` group is root-equivalent
- Requires installing Docker's repository on Rocky Linux

### Rootless Podman advantages

- Native to Fedora/Rocky/Red Hat
- No root daemon
- Better integration with SELinux and systemd/Quadlet

### Rootless Podman disadvantages

- `podman-compose` has compatibility differences from Docker Compose
- This workspace needs `docker-compose.podman.yml` because podman-compose 1.6
  does not preserve `:Z` labels on reused named volumes
- Compose lifecycle output can be noisy when service topology changes

## Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Builds Apache + PHP 8.3 + QloApps |
| `docker-compose.yml` | Base Docker/Podman services and persistent volumes |
| `docker-compose.podman.yml` | Rootless Podman development-only SELinux override |
| `docker/apache/qloapps.conf` | Apache virtual host and sensitive-directory protection |
| `docker/php/entrypoint.sh` | Media seeding, cookie keys, settings, DB readiness |
| `docker/php/configure-database.php` | Applies `SHOP_DOMAIN` to QloApps DB records |
| `docker/php/generate-settings.php` | Generates container `config/settings.inc.php` safely |
| `db/init/01-init.sql` | Local DB seed, imported only when `dbdata` is empty |
| `scripts/backup.sh` | DB, media and cookie-key backup |

## Persistent data

The application source is built into the image. It is not stored in a named
volume. The persistent volumes are:

- `dbdata`: MariaDB data
- `images`: QloApps `img/`
- `uploads`: QloApps `upload/`
- `downloads`: QloApps `download/`
- `secrets`: generated cookie keys

Do not use `docker compose down -v` or `podman-compose down -v` unless all data
has been backed up and a full reset is intended.

## Environment

Create a local environment file:

```bash
cp .env.example .env
```

Set at least:

```dotenv
DB_NAME=qloapps
DB_USER=qloapps
DB_PASSWD=use_a_development_password
MARIADB_ROOT_PASSWORD=use_a_different_root_password
DB_PREFIX=qlo_
HTTP_PORT=8081
SHOP_DOMAIN=localhost:8081
```

`SHOP_DOMAIN` must not contain `http://`, `https://`, or a path. A port is
allowed for development. The web entrypoint updates both `qlo_shop_url` and
the `PS_SHOP_DOMAIN` configuration values every time it starts.

Cookie keys may remain empty on a new development install. The entrypoint
generates valid persistent keys in the `secrets` volume. Existing sites should
provide all three existing keys together if old browser cookies must remain
valid.

The `.env` file is ignored by Git. Do not commit it.

## Database seed

This customized checkout has no QloApps `install/` directory. A database dump
is therefore required for a fresh container database.

Place a dump at:

```text
db/init/01-init.sql
```

MariaDB imports scripts under `db/init/` only when `dbdata` is empty. The SQL
dump is ignored by Git and must be transferred securely with the deployment.

If the DB is empty, the web container exits with:

```text
QloApps database is empty. Restore a database dump before starting the web service.
```

## Local development with Podman

The Fedora workspace uses rootless Podman and `podman-compose`:

```bash
podman-compose \
  -f docker-compose.yml \
  -f docker-compose.podman.yml \
  up -d --build
```

Check status:

```bash
podman ps --filter name=qloapps
```

Follow web logs:

```bash
podman logs -f qloapps_web_1
```

Open:

- Front office: `http://localhost:8081/`
- Admin: `http://localhost:8081/hotel-admin/`

After source changes, rebuild and recreate the web service:

```bash
podman-compose \
  -f docker-compose.yml \
  -f docker-compose.podman.yml \
  build web

podman-compose \
  -f docker-compose.yml \
  -f docker-compose.podman.yml \
  up -d --force-recreate web
```

Podman Compose may recreate the whole pod. Named volumes remain persistent.

Stop without deleting data:

```bash
podman-compose \
  -f docker-compose.yml \
  -f docker-compose.podman.yml \
  stop
```

## Local development with Docker

Do not use the Podman override with Docker:

```bash
docker compose up -d --build
docker compose ps
docker compose logs -f web
```

After source changes:

```bash
docker compose build web
docker compose up -d --force-recreate web
```

## Backups

Create a backup:

```bash
./scripts/backup.sh
```

The script detects Docker Compose or podman-compose and writes:

- `db-<timestamp>.sql`
- `media-<timestamp>.tar.gz`
- `secrets-<timestamp>.tar.gz`

The default destination is `./backups/`, which is ignored by Git.

Stop the web service before a full restore. Restore MariaDB with:

```bash
docker compose exec -T db sh -c \
  'exec mariadb -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" "$MARIADB_DATABASE"' \
  < backups/db-YYYYMMDD-HHMMSS.sql
```

Restore media with:

```bash
docker compose exec -T web tar -C /var/www/html -xzf - \
  < backups/media-YYYYMMDD-HHMMSS.tar.gz
```

Restore generated keys with:

```bash
docker compose exec -T web tar -C /var/lib/qloapps-secrets -xzf - \
  < backups/secrets-YYYYMMDD-HHMMSS.tar.gz
```

Use the equivalent `podman-compose -f ...` command for Podman.

## Rocky Linux 9: Docker Engine installation

These commands require `sudo`:

```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
```

Optionally allow the current user to run Docker without typing `sudo`:

```bash
sudo usermod -aG docker "$USER"
```

Log out and back in after changing group membership. Remember that this grants
root-equivalent access.

Verify:

```bash
docker version
docker compose version
```

## Rocky Linux 9: Podman alternative

Podman is the native Red Hat-family option:

```bash
sudo dnf -y install podman podman-compose
podman version
podman-compose version
```

After installation, normal rootless Podman commands do not require `sudo`.

## Rocky Linux firewall

For a future public deployment:

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

For development, expose only `HTTP_PORT` and restrict it with VPS firewall or
security-group rules.

## Before public production

This development stack is not yet the final production deployment. Before the
Rocky VPS goes public:

1. Use strong unique DB credentials.
2. Set `SHOP_DOMAIN` to the real hostname without a scheme.
3. Put Apache behind an HTTPS reverse proxy or add managed TLS.
4. Do not use `docker-compose.podman.yml` with Docker production.
5. Schedule and test database/media backups.
6. Change all default QloApps admin and test-customer credentials.
7. Add monitoring, log rotation and resource limits.
8. Test payment webhooks through the public HTTPS hostname.

Apache recognizes `X-Forwarded-Proto: https`, which prevents incorrect scheme
detection when TLS terminates at a trusted reverse proxy.

## Troubleshooting

### Redirects to the wrong hostname or port

Set `SHOP_DOMAIN` correctly and recreate `web`. The startup script updates
`qlo_shop_url`, `PS_SHOP_DOMAIN`, and `PS_SHOP_DOMAIN_SSL`.

### Web container says the database is empty

The database seed was absent when `dbdata` was created. Restore a DB backup, or
reset only after backing up and confirming a full development reset is wanted.

### Permission denied on Fedora/Rocky with rootless Podman

Use both Compose files, including `docker-compose.podman.yml`. Do not apply that
override to public Docker production.

### Code changes do not appear

Application code is immutable inside the image. Rebuild and force-recreate
`web`. Do not delete database or media volumes.

### Admin returns a Defuse key error

Provide all three cookie keys together or leave all three empty. A valid
`NEW_COOKIE_KEY` is 136 characters and begins with `def00000`.

### Upload returns HTTP 413

The Apache stack uses PHP's 20 MB upload limit and does not have nginx's old
1 MB default limit. If a reverse proxy is added later, increase its body-size
limit too.
