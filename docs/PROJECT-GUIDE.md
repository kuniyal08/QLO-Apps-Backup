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
- **Current pattern:** `css/custom.css` (M3 tokens) + `css/material.css` (M3 components) are loaded via explicit `<link>` tags at the end of `<head>` in `header.tpl` (after the `$css_files` loop → they override theme + module CSS). The old `@import url("custom.css");` tail of `global.css` is a **no-op — browsers ignore trailing `@import`** (observed: `custom.css` was not even requested). Prefer `<link>` over trailing `@import`.
- `js/material.js` (ripple, scroll state, nav-toggle stopPropagation) loaded from footer via `$smarty.const._THEME_JS_DIR_`.
- Page-specific CSS/JS: add `addCSS()`/`addJS()` in the controller or via the `displayHeader` hook.

### Module template overrides (how they resolve)

- `Module::_isTemplateOverloadedStatic()` (classes/module/Module.php:2412) checks `_PS_THEME_DIR_.modules/<name>/<tpl>` then `.../views/templates/hook/<tpl>` → theme override wins; else module dir.
- **Gotcha:** if the hook entry template (e.g. `landingPageSearch.tpl`) `{include file="./searchForm.tpl"}`s a sub-template, the relative path resolves against the *entry* template's own location. Override the **entry template too**, otherwise the module's sub-template is loaded and your override is bypassed.
- Every id/class/input-name the module JS (`wk-room-search-block.js`) touches must be preserved: `#search_hotel_block_form`, `#search_form_fields_wrapper`, `#hotel_location`, `#location_category_id`, `#id_hotel_button` (`.chosen`), `#daterange_value(_from/_to)`, `#check_in_time`, `#check_out_time`, `#guest_occupancy`, `#search_occupancy_wrapper`, occupancy classes, `#search_room_submit`.

### Current customization status (child theme)

| Item | Status |
|------|--------|
| `css/custom.css` (M3 tokens: palette, shape, elevation, fonts) | Loaded via `<link>` in `header.tpl`; served (HTTP 200) |
| `css/material.css` (M3 components + page restyles, ~31 KB) | Loaded via `<link>` after `custom.css` |
| `js/material.js` | Footer, `_THEME_JS_DIR_` |
| `modules/wkroomsearchblock/.../{searchForm,landingPageSearch}.tpl` | Theme override; M3 labelled fields + icons |
| `css/global.css` | Parent copy; trailing `@import "custom.css"` is a no-op (keep or remove) |
| `preview.jpg` | Custom farmhouse image (replaces parent) |
| `modules/bankwire` & `cheque` translations | Extra en/it/fr files present |

**Known issues / gotchas (observed on real pages):**
- `.app-nav > div` forced `.layer_cart_overlay` visible (`display:flex`) — the blockcart overlay lives inside the `displayTop` hook output, which sits in `.app-nav`. Now excluded (`display:none !important`).
- `#menu_cont` drawer closed instantly on toggle: blocknavigationmenu's document click handler only exempts `.header-top .header-top-menu .nav_toggle`; our toggle is in `.app-nav`, so `material.js` calls `stopPropagation()` on `.nav_toggle`.
- Module CSS uses `#search_hotel_block_form .header-rmsearch-input { min-height: 55px }` and `#search_hotel_block_form #search_room_submit { min-height: 55px; border-radius: 4px; text-transform: uppercase }` — override with equal-or-higher specificity (`#search_hotel_block_form #search_room_submit`) and `min-height`.
- `#xs_room_search_form` (fancybox target) is present on **all** sizes — don't scope desktop/mobile rules by that id alone; use the width media query.
- **Mobile horizontal bleed:** every page overflows 15px on small screens from Bootstrap `.row` negative margins (`.row`/columns at `left:-15; right:390`). Fixed globally with `html, body { overflow-x: clip }` inside the `max-width: 767px` media query (kept drawer + sticky working).
- **Contact form box:** module CSS `css/contact-form.css` styles `.htl-contact-page .contact-form-box` (padding 30px, radius 4px, old blue shadow) with **higher specificity** than a bare `.contact-form-box` rule — override must match `.htl-contact-page .contact-form-box`.
- **Checkout summary selectors:** OPC "Rooms & Price Summary" does **not** use `#cart_summary` (that table only appears inside the classic payment block `order-payment-classic.tpl`). The OPC room lines are `.cart_product_line` in `shopping-cart-detail.tpl`; totals are `.cart_total_detail_block` in `cart-total-block.tpl`.
- **Payment options markup:** payment modules (bankwire/cheque) render `.payment_module` `<a>` links via `#HOOK_PAYMENT`, not `.payment-option` — style `.paiement_block` + `#HOOK_PAYMENT .payment_module`.
- **Add-to-cart requires occupancy selection:** `ajax-cart.js:getBookingOccupancyDetails()` returns falsy until a `.occupancy_info_block.selected` exists. On category/product, open `.booking_guest_occupancy` dropdown and click `.submit_occupancy_btn` (Done) first; only then `.ajax_add_to_cart_button` / `#add_to_cart` adds the room. In headless tests, use `page.click` (real click) not `el.click()` for drawer toggles — jQuery-delegated handlers bind reliably either way, but drawer state is easiest to assert with real clicks.
- **Demo DB gaps (fixed 2026-08-06, client-approved):** `qlo_newsletter` was missing → account creation 500'd in `AuthController::processCustomerNewsletter` (blocknewsletter queries the table); recreated with standard PrestaShop schema. `qlo_currency` was empty (config `PS_CURRENCY_DEFAULT=1` pointed at nothing) → all prices rendered `0` and `#HOOK_PAYMENT` said "No currency has been selected."; inserted INR (id=1, sign ₹, rate 1.0).
- **OPC payment-step reachability:** the payment accordion is lazy — content renders only after proceeding past the summary/guest steps. `proceed_to_payment=1` requires TOS (`#cgv`) checked, and a delivery address (there's a hidden 4th checkout step). With an empty/odd cart, `proceed_to_payment` navigations can drop the cart; don't rely on it for styling a cart (add to cart on the same session right before).

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
