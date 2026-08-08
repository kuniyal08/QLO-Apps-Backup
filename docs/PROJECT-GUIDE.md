# QloApps Project Guide

Working reference for customizing this QloApps hotel booking platform. Keep this file updated as the project evolves.

## Project Status

- **Platform:** QloApps 1.7.0 (PrestaShop 1.6.1.23 fork)
- **Active theme:** `themes/my-farmhouse-child-theme/` (a full copy of `hotel-reservation-theme`)
- **Local deployment:** Apache/PHP container on `http://localhost:8081` (see [Deployment](#deployment))
- **Admin panel:** `http://localhost:8081/hotel-admin/` — login `admin@example.com` / `admin123`

## Stack & Requirements

- PHP 8.1–8.4 (container uses PHP 8.3)
- MySQL 5.7+/MariaDB (container uses MariaDB 10.11 LTS)
- Required extensions: PDO_MySQL, cURL, OpenSSL, SOAP, GD, SimpleXML, DOM, Zip, Phar
- Smarty 3.x templates, jQuery frontend
- No Composer vendor deps needed for runtime (composer.json only lists extensions)

## Architecture

### Request lifecycle

```
index.php → config/config.inc.php → Dispatcher::dispatch() → Controller::run()
  run(): init → checkAccess → setMedia → postProcess → initHeader → initContent → initFooter → display()
  display(): renders content .tpl into theme layout.tpl via Smarty
```

### Key classes to extend

| Purpose | Base class | Location |
|---------|-----------|----------|
| Core model | `ObjectModel` (`$definition` array) | `classes/` |
| Front controller | `FrontController` | `controllers/front/` |
| Admin controller | `AdminController` | `controllers/admin/` |
| Module | `Module` (`hookXxx()` methods) | `modules/{name}/` |
| Module front controller | `ModuleFrontController` | `modules/{name}/controllers/front/` |
| Override | same name + `extends {Class}Core` | `override/` |

### Global helpers (`config/alias.php` + `classes/Tools.php`)

`pSQL()` (SQL escape), `bqSQL()` (identifier escape), `Tools::getValue()`, `Tools::safeOutput()`, `Validate::isXxx()`, `Configuration::get/updateValue`, `Db::getInstance()`.

### Overrides

- Overrides live in `override/` (mirror of `classes/` tree), must extend the `Core` class.
- Delete `cache/class_index.php` after adding/removing overrides.
- Prefer hooks/modules over overrides (overrides can conflict).

### Caching — clear after changes

```bash
rm -rf cache/smarty/compile/* cache/smarty/cache/*
rm -f cache/class_index.php
```

## Frontend / Theme System (focus area)

### How themes work

- The active theme is **DB-driven**: `qlo_theme` table → `qlo_shop.id_theme`.
- There is **no true child-theme inheritance** — `my-farmhouse-child-theme/` is a **full copy** of the parent. Edits in the child fully replace the parent file (no fallback).
- Always edit the **child theme**, never the parent.
- `config/defines_uri.inc.php` sets `_THEME_DIR_` to the active theme directory.

### Page skeleton

`layout.tpl` → `header.tpl` + content template + `footer.tpl` + `global.tpl`.

- **header.tpl** — logo, `displayNav` / `displayTop` / `displaySearchHotelPanel` hooks (search form), banner.
- **footer.tpl** — `displayFooter` + `displayAfterDefautlFooterHook`.
- **index.tpl** — homepage; `displayHomeTab` / `displayHome` hooks only.

### Key frontend pages & where they live

| Page | URL | Template (child theme) | Controller | Data source |
|------|-----|------------------------|------------|-------------|
| Homepage | `/` | `index.tpl` | `controllers/front/IndexController.php` | module hooks (`displayHome`, `displayHomeTab`) |
| Our Properties | `?controller=our-properties` | `our-properties.tpl` | `OurPropertiesController.php` | `HotelBranchInformation::hotelBranchesInfo()` |
| Room list (search results) | `?controller=category&id_category=X&date_from=..&date_to=..` | `category.tpl` + `_partials/room_type_list.tpl` | `CategoryController.php` | `HotelBookingDetail::dataForFrontSearch()` |
| Room detail / booking form | `?controller=product&id_product=X` | `product.tpl` + `_partials/booking-form.tpl` | `ProductController.php` | `HotelRoomType`, `HotelRoomTypeFeaturePricing` |
| Cart | `?controller=cart` | `shopping-cart.tpl` | `CartController.php` | `HotelCartBookingData` |
| Checkout | `?controller=order-opc` | `order-opc.tpl` | `OrderOpcController.php` | `CheckoutProcess` |

### Module templates feeding the frontend

These render via hooks and have **their own template dirs** (edit in child theme's `modules/` override dir OR the module dir):

| Module | Hook | Template | Purpose |
|--------|------|----------|---------|
| `wkroomsearchblock` | `displaySearchHotelPanel` | `modules/wkroomsearchblock/views/templates/hook/searchForm.tpl` | The booking search form (`#search_hotel_block_form`) |
| `wkhotelroom` | `displayHome`/`displayHomeTab` | module views | Homepage room blocks |
| `wkabouthotelblock` | `displayHome` | module views | About-the-hotel section |
| `wkhotelfeaturesblock` | `displayHome` | module views | Features/amenities |
| `wktestimonialblock` | `displayHome` | module views | Testimonials |
| `blockcart` | `displayTop` | module views | Cart summary |

The child theme has a `modules/` directory mirroring these — override templates there to customize.

### CSS/JS loading

- `FrontController::setMedia()` (classes/controller/FrontController.php:1145) loads `_THEME_CSS_DIR_.'global.css'` and `_THEME_JS_DIR_.'global.js'` automatically.
- **Farmhouse pattern (supersedes the older M3 `custom.css`/`material.css` pair — those files are deleted):** the override layer is loaded via explicit `<link>` tags at the end of `<head>` in `header.tpl` (after the `$css_files` loop → they override theme + module CSS):
  1. `css/design-system.css` — design tokens (palette, type scale, elevation, radius), Fraunces/Manrope `@font-face`, global `overflow-x: clip`.
  2. `css/components.css` — always-loaded components (sticky header shell, search-panel neutralisation, footer, cards, buttons, history table, 404 card).
  3. Page overlays: `home.css` (index only), `product_list.css` (category/our-properties/product), `product.css` (product only), `order-opc.css` (checkout), `account.css` (account/utility pages, added in `header.tpl` for `authentication|my-account|identity|addresses|address|order-confirmation|order-detail|history|guest-tracking`), plus appended overlays in the stock per-page files (`identity.css`, `addresses.css`, `contact-form.css`, `cms.css`, `stores.css`, `maintenance.css`, `my-account.css`, `order-confirmation.css`, `order-detail.css`).
- `js/theme.js` (vanilla, `defer`) loaded from `<head>` via `header.tpl` — sticky header shadow, mobile nav drawer. No new jQuery; module JS (`order-opc.js`, `product.js`, `occupancy.js`, `wk-room-search-block.js`) is untouched.
- Page-specific CSS/JS: add `addCSS()`/`addJS()` in the controller or via the `displayHeader` hook.

### Module template overrides (how they resolve)

- `Module::_isTemplateOverloadedStatic()` (classes/module/Module.php:2412) checks `_PS_THEME_DIR_.modules/<name>/<tpl>` then `.../views/templates/hook/<tpl>` → theme override wins; else module dir.
- **Gotcha:** if the hook entry template (e.g. `landingPageSearch.tpl`) `{include file="./searchForm.tpl"}`s a sub-template, the relative path resolves against the *entry* template's own location. Override the **entry template too**, otherwise the module's sub-template is loaded and your override is bypassed.
- Every id/class/input-name the module JS (`wk-room-search-block.js`) touches must be preserved: `#search_hotel_block_form`, `#search_form_fields_wrapper`, `#hotel_location`, `#location_category_id`, `#id_hotel_button` (`.chosen`), `#daterange_value(_from/_to)`, `#check_in_time`, `#check_out_time`, `#guest_occupancy`, `#search_occupancy_wrapper`, occupancy classes, `#search_room_submit`.

### Current customization status (child theme) — farmhouse redesign

| Item | Status |
|------|--------|
| `css/design-system.css` (farmhouse tokens: Fraunces/Manrope fonts, warm earth palette, spacing/elevation/radius) | Loaded via `<link>` in `header.tpl`; served (HTTP 200) |
| `css/components.css` (always-on overlay: sticky header, search panel, cards, footer, history/404) | Loaded via `<link>` after `design-system.css` |
| Page overlays: `home.css`, `product_list.css`, `product.css`, `order-opc.css`, `account.css` + appended per-page overlays (`identity`, `addresses`, `contact-form`, `cms`, `stores`, `maintenance`, `my-account`, `order-confirmation`, `order-detail`) | Loaded via `<link>` conditionals in `header.tpl` / stock controller `addCSS()` |
| `fonts/fraunces-*.woff2`, `fonts/manrope-latin-200-800.woff2` | Self-hosted, `font-display: swap` |
| `js/theme.js` | Vanilla, `defer` in `<head>` |
| `modules/wkroomsearchblock/.../roomTypePageSearch.tpl` + 4 byte-identical search overrides | Sticky search panel on product page ("Modify Search" toggle) |
| `header.tpl` / `footer.tpl` / `index.tpl` / `category.tpl` / `product.tpl` | Rebuilt farmhouse shell, hero, sections, room cards, sticky booking widget |
| `css/product_list.css` (396→900 lines) | Category/our-properties room cards |
| **Superseded:** `css/custom.css` + `css/material.css` (M3 iteration) + `js/material.js` | Deleted — replaced by the farmhouse layer above |

**Known issues / gotchas (observed on real pages):**
- **Payment step shows "No payment method is available"** when `qlo_module_currency`/`qlo_currency_shop` are empty: `PaymentModule::getCurrency()` (classes/PaymentModule.php:1732) → `Currency::getPaymentCurrencies()` LEFT JOINs `module_currency`, and `getCurrenciesByIdShop()` LEFT JOINs `currency_shop`. **Fixed 2026-08-08 (client-approved):** `INSERT INTO qlo_currency_shop (id_currency, id_shop, conversion_rate) VALUES (1,1,1.000000)` and `INSERT INTO qlo_module_currency (id_module, id_shop, id_currency) VALUES (10,1,1),(11,1,1)` (bankwire=10, cheque=11).
- **OPC payment-step reachability:** the payment accordion is lazy — content renders only after proceeding past the summary/guest steps. `HOOK_PAYMENT` also guards on TOS (`#cgv` checked) and a valid delivery address. Automating the flow: summary "Proceed" → guest-info step → `#customer_guest_detail` checkbox → fill `customer_guest_detail_*` fields → click `.submit-guest-details` → TOS checkbox → payment modules appear.
- **Guest checkout is disabled** (`PS_GUEST_CHECKOUT_ENABLED=0`); order-opc shows login + full create-account forms. Registration is two-step on the auth page (`#email_create` → `#SubmitCreate` → full form → `#submitAccount`).
- **`.pagenotfound` ambiguity:** `body` carries both `id="pagenotfound"` and `class="pagenotfound"` (header.tpl sets id+class from `$page_name`) — target the inner `div.pagenotfound` with `#center_column .pagenotfound` (or `body > div`), never `document.querySelector('.pagenotfound')` in QA scripts.
- **`account.css` 404:** `header.tpl` loads `css/account.css` on account pages; the file must exist (added 2026-08-08) or browsers log "Refused to apply style ... MIME type text/html".
- **Multiple search pills:** `hotelreservationsystem` `displayAfterHookTop` + `headerHotelDescBlock.tpl` recursively call `displayAfterHeaderHotelDesc`, so `#xs_room_search` appears twice (one hidden via `#index .header-desc-container {display:none}`) — use `.first()`.
- **Modify Search on product page:** the desktop `.modify_roomtype_search_btn` (without `.visible-xs`) toggles the hidden `.fh-search-panel--sticky` (`display:none` in module CSS by design).
- **`.header-rmsearch-wrapper` is `display:none`** in `wk-roomtype-search.css` — the room-page search panel opens only via Modify Search; do not force it visible.
- **Datepicker cells** are plain `td` (no `.day` class) inside `.date-picker-wrapper`; use `td:not(.disabled):not(.prev-month):not(.next-month)` in tests.
- **Order placement in tests** creates real orders (`qlo_orders`, `qlo_htl_booking_detail`) — refs like `PKFXMRHWM`; harmless in dev.
- **Demo DB gaps (fixed 2026-08-06, client-approved):** `qlo_newsletter` missing → account creation 500'd; recreated with standard schema. `qlo_currency` empty → prices `0`; inserted INR (id=1).

## Booking Flow (context for styling)

```
SEARCH (wkroomsearchblock) → CATEGORY page (availability) → PRODUCT page (booking form)
→ CART (HotelCartBookingData::addCartBookingData) → CHECKOUT (OrderOpcController)
→ PAYMENT module validateOrder() → PaymentModule.php:735 converts cart → htl_booking_detail
→ ORDER CONFIRMATION (OrderConfirmationController)
```

- Availability engine: `modules/hotelreservationsystem/classes/HotelBookingDetail.php` — `getBookingData()` (line 273), `dataForFrontSearch()` (line 1678).
- Add-to-cart: `controllers/front/CartController.php:294` (`processChangeProductInCart`).
- Room freeing on cancel/refund: `modules/hotelreservationsystem/hotelreservationsystem.php:478`.

## Conventions (from AGENTS.md)

- **Translations:** module → `$this->l()`; core front → `Tools::displayError()`; core template → `{l s='...'}`; module template → `{l s='...' mod='modulename'}`. Never hardcode user-facing strings.
- **Multi-language:** always include `id_lang` in translatable queries; use `Context::getContext()->language->id`.
- **Database:** `_DB_PREFIX_` for tables (e.g. `qlo_htl_room_type`); `pSQL()` strings, `(int)` ids; prefer `ObjectModel` over raw SQL.
- **Security:** `Tools::getValue()` for input, `Tools::safeOutput()` / `{escape}` for output, never log/expose secrets.
- **Module work:** don't modify core; use hooks; overrides only as last resort.
- **Naming:** PascalCase classes, camelCase methods/vars, UPPER_SNAKE constants.

## Deployment

### How to start locally (dev sandbox)

The verified development stack is Apache + PHP 8.3 + MariaDB 10.11.

Rootless Podman does not require sudo to run containers. Use the Podman
override because podman-compose 1.6 does not preserve SELinux `:Z` labels on
recreated named volumes.

```bash
podman-compose \
  -f docker-compose.yml \
  -f docker-compose.podman.yml \
  up -d --build

# Front: http://localhost:8081/
# Admin: http://localhost:8081/hotel-admin/
```

Docker Engine users run `docker compose up -d --build` without the Podman override.

See `docs/DEPLOYMENT-REDHAT.md` for full development, backup and later Rocky
Linux VPS instructions.

### Database

- Internal host `db:3306`; DB name/user/password/prefix come from `.env`.
- `config/settings.inc.php` is generated inside `web`; cookie keys persist in a named `secrets` volume.
- `db/init/01-init.sql` is imported only when `dbdata` is empty and is ignored by Git.
- `SHOP_DOMAIN` updates `qlo_shop_url` and `PS_SHOP_DOMAIN*` on every web start.
- Persistent data: `dbdata`, `images`, `uploads`, `downloads`, `secrets`.
- Never run Compose `down -v` unless a backed-up full reset is explicitly intended.
- Run `./scripts/backup.sh` for DB, media and cookie-key backups.

### Install gotchas (recorded for future re-installs)

- The repo ships **without** `install/` and without a portable `config/settings.inc.php`. To (re)install outside the seeded container flow:
  1. Download the matching release zip (`https://github.com/Qloapps/QloApps/releases`) and copy its `install/` folder in.
   2. In the web container, run the CLI installer with `--db_server=db`, credentials from `.env`, prefix `qlo_`, and the hostname from `SHOP_DOMAIN`.
  3. The **fixtures step fails** on GD image generation (PHP 8.5) and dies, aborting the `modules`/`theme` steps. Run them separately: `--step=modules`, then register the child theme via SQL.
  4. **Remove/rename `install/`** after install — while it exists the admin login form is hidden (security check in `AdminLoginController.php:99`).
   5. Set `SHOP_DOMAIN`; the container updates `qlo_shop_url.domain` and `PS_SHOP_DOMAIN`/`PS_SHOP_DOMAIN_SSL` (otherwise requests redirect to the wrong host).
  6. If the admin employee is missing (fixtures died), insert manually:
     `passwd = md5(_COOKIE_KEY_ . 'password')` (verified against `Tools::encrypt()`).

### Admin password note

Passwords are stored as `md5(_COOKIE_KEY_ . $plain)` and the plain password is submitted by the login form (no client-side hashing in this build). Verify with `Tools::encrypt($pwd)`.

## Where do I look for X?

| Task | File(s) |
|------|---------|
| Homepage layout | `themes/my-farmhouse-child-theme/index.tpl` + `IndexController.php` |
| Search/booking form styling | `wkroomsearchblock/views/templates/hook/searchForm.tpl` |
| Hotel property cards | `our-properties.tpl` + `OurPropertiesController.php` |
| Room type cards (results) | `_partials/room_type_list.tpl` + `CategoryController.php` |
| Room detail booking form | `product.tpl` + `_partials/booking-form.tpl` + `ProductController.php` |
| Header/nav/footer | `header.tpl`, `footer.tpl`, `layout.tpl` |
| Add a stylesheet | append to `css/custom.css` |
| Availability/pricing logic | `modules/hotelreservationsystem/classes/HotelBookingDetail.php` |
| Room type / hotel models | `modules/hotelreservationsystem/classes/HotelRoomType.php`, `HotelBranchInformation.php` |
| Cart→order conversion | `classes/PaymentModule.php` (line ~735) |
| Admin hotel management | `modules/hotelreservationsystem/controllers/admin/` |
