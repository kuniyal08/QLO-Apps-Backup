# AGENTS.md

## Project Overview

QloApps is an open-source hotel reservation and property management platform. It enables hotels to manage rooms, bookings, guests, and payments through a web-based system.

## Purpose of this File

This document provides guidance for AI coding agents contributing to the QloApps project. It defines conventions, safety rules, and workflows to ensure consistent and secure code generation.

## Technology Stack

- **Language:** PHP 8.1–8.4 (backend), Smarty 3.x (templates), JavaScript/jQuery (frontend)
- **Database:** MySQL 5.7, 8.0+; MariaDB 10.5, 10.6, 10.11, 11.0, 11.2, 11.4
- **Architecture:** MVC with hook-based module system
- **License:** OSL-3.0 (core), AFL-3.0 (modules)
- **Required PHP Extensions:** PDO_MySQL, cURL, OpenSSL, SOAP, GD, SimpleXML, DOM, Zip, Phar

## Environment Setup

Install dependencies:
```bash
composer install
```

Clear caches:
```bash
rm -rf cache/smarty/compile/* cache/smarty/cache/*
rm -f cache/class_index.php
```

Clear class cache after adding or modifying overrides.

## Project Structure

```
.
├── classes/              # Core models extending ObjectModel
├── controllers/          # Front and admin controllers
│   ├── admin/
│   └── front/
├── modules/              # Feature modules with isolated functionality
├── override/             # Core class and controller overrides
├── themes/               # Smarty templates (.tpl files)
├── config/               # Configuration files (settings.inc.php contains secrets)
├── cache/                # Generated cache files
├── tests/                # PHPUnit test suite
```

**QloApps Agent Skills:** Install reusable development skills using:
```bash
npx skills add Qloapps/agent-skills
```
Available skills: module-development, payment-module-development, stats-module-development. Check installed skills before implementing new functionality.

## Architecture Overview

**MVC Pattern**
- Models: classes/ extending ObjectModel
- Controllers: FrontController or AdminController
- Views: Smarty templates (.tpl)

**Modules**
- Located in modules/<modulename>/
- Provide isolated functionality
- Integrate using hooks

**Overrides**
- Located in override/
- Extend core classes using the Core suffix
- Clear class cache after creating overrides

**Context**
- Access runtime objects using Context::getContext()

## Core vs Module Development Rules

**When working on a module:**
1. Never modify core files directly
2. Use **hooks** to integrate module functionality into core features
3. If no suitable hook exists, create a **custom hook** — but only if the hook placement is generic and useful for other modules too
4. Use **overrides** only as a last resort — overrides can conflict with other module override files and require manual resolution

**When working on a core feature:**
- Make changes directly in core files
- Do not use hooks or overrides for core-to-core changes

## Coding Conventions

**Classes:** PascalCase — `HotelBookingData`
**Methods:** camelCase — `getBookingDetails()`
**Variables:** camelCase — `$hotelId`
**Constants:** UPPER_SNAKE_CASE — `BOOKING_STATUS_CONFIRMED`
**Database Tables:** _DB_PREFIX_ + lowercase_snake — `qlo_hotel_booking`
**Config Keys:** MODULENAME_SETTING — `HOTELRESERVATION_ENABLED`
**Files:** One class per file, filename matches class name
**Templates:** lowercase-hyphens.tpl — `booking-form.tpl`

Add PHPDoc blocks to all classes and methods.

## Translation

Never hardcode user-facing English strings — always wrap them in the appropriate translation method.

| Context | Method |
|---------|--------|
| Module main file | `$this->l('string')` |
| Module admin controller | `$this->l('string')` |
| Module front controller | `$this->module->l('string', 'controllerName')` |
| Module classes | `$objModule->l('string', 'ClassName')` |
| Core admin controller | `$this->l('string')` |
| Core front controller | `Tools::displayError('string')` |
| Smarty template (core) | `{l s='string'}` |
| Smarty template (module) | `{l s='string' mod='modulename'}` |

## Multi-language

- Always include `id_lang` in queries that return translatable content
- Use `Context::getContext()->language->id` for the current language

## Module Development Guidelines

**Module Location:** modules/<modulename>/

**Required Files:**
- <modulename>.php — Main class extending Module
- config.xml — Module metadata

**Optional Directories:**
- classes/ — Module-specific models
- controllers/ — Module controllers
- views/templates/ — Smarty templates
- upgrade/ — Version migration scripts

**Hook Integration:**
- Register hooks in install() method
- Unregister hooks in uninstall() method
- Keep hook handlers lightweight

**Configuration:**
- Store settings using Configuration::updateValue()
- Retrieve settings using Configuration::get()
- Prefix config keys with module name

## Database Rules

**Table Prefix:** Always use _DB_PREFIX_ constant instead of hardcoding the table prefix

**Escaping:**
- Strings: pSQL($value)
- Integers: (int)$value
- Table/column names: bqSQL($name)

**Preferred Access:** Use ObjectModel for CRUD operations instead of raw SQL queries

**Prohibited:** Never concatenate raw user input into SQL queries.

## Security Guidelines

**Input Handling**
- Use Tools::getValue() for request parameters
- Cast numeric values to (int)
- Escape strings using pSQL()
- Validate input using Validate class methods

**Output Escaping**
- Use Tools::safeOutput() in PHP
- Use Smarty escape modifiers in templates

**Sensitive Data**
- Never expose config/settings.inc.php
- Never commit API keys, passwords, or tokens

**Authorization**
- Verify permissions before performing admin operations

## Testing

Testing infrastructure is being configured. Check tests/ directory for available tests before running.

## AI Agent Workflow

1. Check installed agent skills before implementing new functionality
2. Search codebase for similar implementations before creating new code
3. Extend existing classes rather than duplicating functionality
4. Follow patterns established in surrounding code
5. Reuse existing utilities: Tools, Validate, Db, Configuration classes
6. Prioritize consistency with existing codebase over new approaches

After making changes:
- Clear caches if modifying templates or overrides
- Add PHPDoc to new methods

## Environment & Tooling Constraints — Notify + Advise

- **Always notify the user about environment/tooling constraints** that affect how a task can be executed in this workspace (e.g., "no root/sudo available", "Docker Engine cannot be installed", "port X is taken", "extension Y missing"). Do not silently pick a workaround.
- **Ask the user** when a constraint changes the recommended approach, instead of merely informing them and proceeding.
- When a choice has tradeoffs, **lay out the advantages and disadvantages** of each option before acting (e.g., Docker Engine needs root/`docker` group vs rootless Podman; build-from-image vs bind-mounted source; seeding from a DB dump vs clean installer).
- If a user-selected tool cannot be used here, **recommend and explain the closest compatible alternative** (e.g., Docker-compatible Podman), and confirm before relying on it.
- Note: Docker Engine requires root (or membership in the `docker` group, which is root-equivalent). Podman is rootless by default.


## Local Dev Stack — Editing Code Live

- The Docker image bakes the source (`COPY . /var/www/html`); host edits are invisible until the image is rebuilt, so use the dev override for iterative work:
  ```bash
  podman-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
  ```
  `docker-compose.dev.yml` bind-mounts `themes/`, `controllers/`, and `cache/` from the host. It is a local-only dev artifact (not for production).
- **SELinux trap (rootless Podman, Enforcing):** `podman-compose 1.6` drops the `:Z` relabel when it *recreates* a container, so named volumes (img/upload/download/secrets) keep the old MCS pair and the new container gets a new one — the entrypoint then fails with `cp: cannot stat '/var/www/html/img/.'` and the container crash-loops. If this happens:
  ```bash
  MCS=$(podman inspect <container> --format '{{.ProcessLabel}}')  # e.g. s0:c110,c112
  for v in images uploads downloads secrets; do
    podman unshare chcon -R -t container_file_t -l "$MCS" "$(podman volume inspect qloapps_$v --format '{{.Mountpoint}}')"
  done
  podman start <container>
  ```
  (`podman unshare` is required — the volume files are owned by the container-mapped UID and plain `chcon` fails with EPERM.) `podman stop/start` keeps the MCS pair; `podman-compose up` recreate changes it again.
- The entrypoint seeds media from `/usr/local/share/qloapps-media` into empty volumes on first boot and regenerates `config/settings.inc.php` from env each start; cookie keys persist in the `secrets` volume.

## Safety Rules

## Git Workflow

- Work from a descriptive feature branch. Never commit directly to `main` or `master`.
- Commit each isolated, verified unit of work promptly.
- Keep commits atomic: one logical change per commit; do not combine refactors and bug fixes.
- Run relevant local validation before staging. Never commit syntax errors, broken code, or failing tests.
- Use Conventional Commits messages in imperative mood, for example `feat(theme): add property discovery cards`.


**Agents must not:**
- Delete files unless explicitly instructed
- Run git commands automatically
- Modify composer.json without approval
- Modify config/settings.inc.php
- Execute DROP, TRUNCATE, or destructive SQL
- Modify core files directly when working on a module (use hooks or override system)

**Agents must:**
- Use pSQL() for strings and (int) for IDs in SQL
- Use Tools::getValue() for request parameters
- Escape all output
- Check installed agent skills before implementing new functionality
- Follow project naming conventions
- Validate inputs before processing

**Agents should ask before:**
- Deleting any files
- Running git commands
- Changing dependencies
- Modifying database schema
- Altering payment or booking logic

---

**Resources:**
- Documentation: https://docs.qloapps.com
- Forum: https://forums.qloapps.com
- GitHub: https://github.com/Qloapps/QloApps
- Security Issues: support@qloapps.com
