# Client Requirements

Running log of the client's needs. Section 1 is the consolidated platform spec (v1); later sections track the redesign implementation. Update as requirements evolve.

## 1. Platform requirements (v1 spec — 250-property rural tourism platform)

> **Context:** Originally scoped as a single hotel ("My Farmhouse Hotel"). The platform will cover **~250 properties in rural Uttar Pradesh**: farmhouses, stay-in homes, and **cultural centers**. Activities / things to do are informational content and are not separately bookable.

### 1.1 Overview / positioning

- Multi-property rural tourism / cultural-stay booking platform in **Uttar Pradesh, India**.
- ~250 properties initially; must be easy to onboard more.
- Property mix: **farmhouses**, **stay-in homes**, **cultural centers**.
- Cultural centers also offer **activities & experiences** (music, dance, craft, food, workshops, heritage walks, festivals, etc.).
- B2C audience: domestic tourists (Hindi/English) and possibly international.
- **Mobile-first** — the site must work great on phones (verified M3 responsive foundation exists).
- Payments: **Razorpay** (UPI, RuPay, cards, netbanking) — embedded checkout.
- Ops: notify **property caretakers** via **SMS and/or email** for bookings/events.

### 1.2 Users & roles

| Role | Needs |
|------|-------|
| **Guest / traveler** | Browse properties and local activities; search/filter and book stays; pay online (UPI/card); get confirmations (email/SMS); manage/cancel bookings; leave reviews |
| **Property caretaker / manager** | Receive stay-booking notifications by SMS/email; (later) limited view of their property's bookings |
| **Platform admin** | Manage 250+ properties, caretakers, rooms, informational activity content, availability, pricing, bookings, payments/refunds and reports |

### 1.3 Properties

- Property profile: name, type, description, location (village/block/district in UP), photos/gallery, amenities, contact, **caretaker contact** (name, mobile, email).
- **Rooms / stay inventory** per property (types, capacity, base price, per-occupancy pricing, max adults/children).
- Availability calendar per property/room; blocked dates; seasonal/off-season pricing.
- Landlord/caretaker assignment + their SMS/email destination.

### 1.4 Activities & experiences (informational only)

- Informational content such as terracotta, chikan craft, boat rides, music, food, workshops, heritage walks and festivals.
- Activities are associated with a property/location and may include a name, category, description, photos, typical duration, season/timing notes and contact/enquiry guidance.
- No activity inventory, capacity, time-slot availability, cart line or activity payment flow.
- Activities may have browse/filter pages and property-page sections for discovery and SEO.
- Add a **home page tab/section** for activities ("Things to do" / "Experiences") in addition to existing property/room sections.

### 1.5 Booking engine

- Booking type: **stays only** through the existing QloApps room/cart/checkout flow.
- Stay booking: check-in/check-out dates, rooms, occupancy (adults/children/rooms).
- Activities do not enter the cart or checkout.
- **Advance/partial payment** support (deposit now, balance later) — QloApps supports this; confirm desired policy.
- Cancellation & refund policies per stay/property; refunds via Razorpay refund API.
- Pricing: GST on accommodation vs services (confirm rates), taxes, convenience fee (optional).

### 1.6 Payments (Razorpay)

- **Razorpay embedded checkout** (checkout.js) — UPI, RuPay, cards, netbanking, wallets.
- Currency **INR** (already the default in current env).
- Flows: create order (paise), verify HMAC signature server-side, capture, update order, redirect to confirmation.
- **Webhook** for async payment confirmations (esp. UPI).
- Refunds via Razorpay API.
- Test (sandbox) vs live mode configurable.
- This is a **custom-built module** (not the paid store module) — mirror the `qlopaypalcommerce` pattern.

### 1.7 Guest accounts

- Registration/login by **email** and/or **mobile + OTP** (Indian users often prefer mobile OTP).
- Guest checkout option (with order tracking by email/phone).
- Booking history, invoices, cancellation, reviews.

### 1.8 Caretaker & guest communication

- **Email** (native) + **SMS** (via a gateway — provider TBD: MSG91, Fast2SMS, Twilio, ValueFirst, Textlocal...).
- Notifications: new stay booking, changes, cancellations, check-in reminders, payment received/refunded.
- Templates for both guest-facing and caretaker-facing messages.
- Caretaker contact stored per property; route notifications accordingly.

### 1.9 Admin / operations

- Property CRUD at scale and informational activity-content management.
- Calendar-based availability & pricing management.
- Booking management, payment/refund handling, order statuses.
- Reports: occupancy, revenue by property, upcoming bookings, caretaker performance.
- Roles/permissions (super-admin vs property manager) — confirm scope.

### 1.10 Frontend / UX

- **Mobile-first responsive** (M3 design already applied; keep).
- Home page: hero + search, property highlights, and a new **Activities / Experiences** tab & section.
- Property landing pages (SEO) with gallery, rooms, activities, reviews.
- Activity information pages/sections (description, photos, location, typical timing and enquiry guidance).
- Booking flow optimized for mobile (fewer steps, OTP login, UPI first).
- **Hindi + English** localization (confirm languages).
- Reviews & ratings for properties; activity reviews are optional future content.

### 1.11 Deployment

- Current purpose: local development and testing with Docker Compose-compatible containers.
- Verified local runtime: Apache + PHP 8.3 and MariaDB 10.11 under rootless Podman.
- Later deployment target: a Rocky Linux VPS using Docker Engine/Compose, HTTPS, backups and monitoring.
- Docker Engine installation requires root/sudo; membership in the `docker` group is root-equivalent.

### 1.12 Non-functional

- 250 properties plus informational activity content; DB/query design, caching and mobile-network performance must scale.
- Backups, restore plan, HTTPS, PHP 8.3 LTS, security patching.
- SEO for rural/local search (property pages indexed).
- Possible future: OTA distribution (Airbnb/MMT/OYO via channel manager), mobile app/PWA.

### 1.13 Open questions / decisions needed

1. **Brand name** (currently "My Farmhouse Hotel" placeholder).
2. **SMS provider** (MSG91 / Fast2SMS / Twilio / other) and who pays.
3. **Advance-payment policy** (deposit %, when balance due).
4. **Cancellation/refund rules** (grace periods, per-property policies).
5. **Languages**: Hindi + English? Any more?
6. **GST/tax setup** (accommodation vs service rates; register for GST).
7. **Admin scope**: caretaker self-service views, or admin-only ops initially?
8. **Reviews/moderation** — public immediately, or phase 2?
9. **Check-in/check-out times, min nights** rules per property.

---

## 2. Platform decision: QloApps (decided 2026-08-07)

- Client selected QloApps rather than a custom HMS.
- QloApps already provides multi-property room search, availability, pricing, stay bookings, checkout and admin operations.
- Activities are informational only, so no separate availability or activity-booking engine is required.
- New functionality should be delivered through QloApps modules/hooks and theme sections rather than replacing the booking platform.
- Caretaker SMS workflows and Razorpay remain custom module/integration work.

---

## 3. Redesign implementation log (single-hotel phase)

### Farmhouse redesign (2026-08-08, replaces the M3 iteration)

The M3 material iteration (`css/custom.css`, `css/material.css`, `js/material.js`) was **superseded and deleted**. The active design system is the farmhouse layer in `themes/my-farmhouse-child-theme/`:

| Area | Delivered / acceptance criteria | Files |
|------|--------------------------------|-------|
| Brand & type | Revived farmhouse identity: deep forest green `#2F4A3C` primary, terracotta accent `#C46A3B`, cream paper `#F7F4EF`; self-hosted **Fraunces** display font (opsz 72) + Manrope/system body; all local, no CDNs | `css/design-system.css`, `fonts/*.woff2` |
| CSS architecture | Stock `global.css` + page CSS kept as functional base (Bootstrap 3/JS compat); farmhouse override layer loaded after it in `header.tpl` | `design-system.css`, `components.css`, page overlays |
| Header / footer | Sticky translucent header (110px) with logo, nav, cart; rebuilt footer with full hook surface (explore links, columns, notification, payment, copyright) | `header.tpl`, `footer.tpl`, `components.css` |
| Homepage | Full-bleed hero with overlapping search panel (pulled up `-150px`), trust strip, interior/amenity/room grids, testimonials | `index.tpl`, `home.css`, module template overrides |
| Search bar | White elevated panel, sticky under header on category/room pages; exact field contract preserved (`hotel_location`, `location_category_id`, `check_in_date`, `check_out_date`, `adult_count`, `child_count`, `number_of_rooms`, `search_hotel_btn`); mobile fancybox pill works | `modules/wkroomsearchblock/.../searchForm.tpl` + 5 overrides |
| Room listing | Booking.com-style cards (4 per grid, aspect-ratio images, primary price, pill CTA) | `category.tpl`, `product_list.css` (396→900 lines) |
| Room detail | Sticky booking widget right column (dates, occupancy, total, Book Now pill), Fraunces title + rating, rounded gallery with thumbnail strip, pill tabs; mobile stacks + sticky card relaxes to static | `product.css` overlay, `roomTypePageSearch.tpl` (Modify Search panel) |
| Checkout | One-page accordion cards (Rooms & Price Summary / Guest Information / Payment Information), room-row cards, totals sidebar card, voucher block, payment module options | `order-opc.css` overlay |
| Account & utility | my-account link cards (grid), booking detail tabs/tables, order confirmation card, auth box forms, contact card, CMS typography, stores, 404 card, guest tracking | `account.css` + per-page overlays (`my-account`, `order-confirmation`, `order-detail`, `identity`, `addresses`, `contact-form`, `cms`, `stores`, `maintenance`) |
| Mobile | No horizontal overflow at 375/768/1440 (verified with Playwright DOM checks on home/category/product/checkout/account/auth/history/contact); touch-friendly pill controls | QA harness `/tmp/opencode/*.js` |
| Functional verification | **Full guest journey placed 2 real orders** (refs `PKFXMRHWM`, `KQLTSTCFV`): register → search → Book Now → checkout summary → guest info → TOS → bankwire payment → confirmation | — |
| DB repair (client-approved) | Payment step showed "No payment method is available": `qlo_currency_shop` and `qlo_module_currency` were empty → inserted INR/shop rows (`currency_shop` 1/1/1.000000; `module_currency` bankwire 10 + cheque 11) | `qlo_currency_shop`, `qlo_module_currency` |
| Deploy/QA invariants | Search form contract, all homepage hooks, sticky header height, no console errors (account.css 404 fixed by adding the file) | — |

Committed on `feature/rural-marketplace-alpha` (2026-08-08): `33917a7` (category), `f563454` (product), `d473176` (checkout), `256df1f` + `d1c0af2` (account pages + account.css), `94a1901` (utility pages).

### De-branding (removed all QloApps / Webkul / "Hotel Prime" references)

Complete. Verified zero visible matches on every front + admin page.

## Theme / branding

> Notes on the palette started in `themes/my-farmhouse-child-theme/css/custom.css`:
> warm off-white (`#f9f7f3`) background, deep slate (`#2c3e50`) header, warm orange (`#e67e22`) accents.

| Requirement | Notes / acceptance criteria | Files to change |
|-------------|----------------------------|-----------------|
| Modern responsive redesign (Material 3) | M3 design system in `css/material.css` (tokens in `custom.css`, loaded last): filled/tonal/outlined buttons, 44px form controls, cards/chips/badges/alerts/tables; Top App Bar (sticky, transparent-on-home → surface on scroll), utility bar, desktop inline pill nav, 300px mobile drawer, hero with floating search card, dark `#17301f` footer; Roboto UI + Playfair headings; `js/material.js` adds ripple, scroll state, nav-toggle stopPropagation | `themes/my-farmhouse-child-theme/css/{custom,material}.css`, `js/material.js`, `{header,footer,index}.tpl` |
| Remove QloApps/Webkul badges | No visible references remain on front or admin | DB (`qlo_htl_branch_info_lang`, `qlo_meta_lang`, `qlo_cms_lang`, `qlo_category_lang`, `qlo_address`, config); admin templates; `img/logo.png`, `img/logo-login.png`, `img/favicon.ico` |

## Homepage

| Requirement | Notes / acceptance criteria | Files to change |
|-------------|----------------------------|-----------------|
| Homepage title | Now just `My Farmhouse Hotel` (index meta title emptied, `classes/Meta.php:240` appends shop name) | `qlo_meta_lang` id_meta=4 |
| M3 search card | Floating elevated card over hero; flex row with labelled fields (Destination / Hotel / Stay Dates / Guests & Rooms) + leading Material icons + Filled "Search Rooms" button; verified via headless Chrome (radius 28px, elevation, 48px fields, no overflow) | `themes/my-farmhouse-child-theme/modules/wkroomsearchblock/views/templates/hook/{searchForm,landingPageSearch}.tpl`, `css/material.css` (`.m3-field` system) |

## Booking / search flow

| Requirement | Notes / acceptance criteria | Files to change |
|-------------|----------------------------|-----------------|
| Mobile booking button opens search | `#xs_room_search` fancybox opens `#xs_room_search_form` with the stacked M3 fields; verified | `css/material.css` (mobile rules), module JS untouched |
| Mobile nav drawer | 300px off-canvas drawer, opens via `.nav_toggle`, closes via `close_navbar` or outside click; `material.js` `stopPropagation` on toggle prevents module's doc-click handler from instantly re-closing; `.layer_cart_overlay` no longer forced visible by `.app-nav > div` rule | `js/material.js`, `css/material.css` |

## Room listing / detail pages

| Requirement | Notes / acceptance criteria | Files to change |
|-------------|----------------------------|-----------------|
| M3 room cards (category/availability page) | 4 room cards: 16px radius, elevation-1, Playfair headings, primary price, Filled "Book Now" pill, 12px-radius images, no overflow; verified via headless Chrome | `css/material.css`, `_partials/room_type_list.tpl` (CSS-only restyle) |
| M3 product detail + booking form | `#image-block` 16px radius, `.pb-right-column` elevated card, Filled Book Now (`button.exclusive`), M3 booking fields (48px filled, date inputs, occupancy), primary 700 22px total price | `css/material.css`, `_partials/booking-form.tpl`, `product.tpl` (CSS-only) |
| Add-to-cart works | Book Now requires occupancy selection first (`.booking_guest_occupancy` → Done marks `.occupancy_info_block.selected`); then `.ajax_add_to_cart_button` adds room; verified end-to-end (cart qty 1, `#layer_cart` shows) | module JS + `occupancy_field.tpl` (unchanged), test harness `/tmp/opencode/add-cart2.js` |

## Checkout / cart / account (Phase C)

| Requirement | Notes / acceptance criteria | Files to change |
|-------------|----------------------------|-----------------|
| M3 checkout (order-opc) | Accordion cards (Rooms & Price Summary / Guest Information / Payment Information) = 16px radius + surface + elevation; room summary lines are individual M3 cards; `.room_duration_block` surface-container pill; totals right column elevated card; verified 1440px + 375px, no overflow | `css/material.css` (section 8) |
| M3 add-to-cart confirmation layer | `#layer_cart` = 16px radius + elevation-3 + surface bg; rows separated; Continue = outlined, Proceed = Filled | `css/material.css` |
| M3 auth / account / forms | Auth `.box`, my-account cards, identity & address `.box` forms = 16px radius elevated cards; 44px inputs; submit buttons Filled/tonal pills; contact `.htl-contact-page .contact-form-box` = M3 card + Filled Send button | `css/material.css` (section 9) |
| M3 payment options | `.paiement_block` elevated card; `#HOOK_PAYMENT .payment_module` list-item options; `.radio`/`.checkbox` pills; `#cgv` TOS checkbox pill | `css/material.css` (payment rules; note: actual payment render needs currency + address step + TOS) |
| Mobile horizontal-overflow fix | Every page bled 15px on mobile (Bootstrap `.row` negative margins) → `html, body { overflow-x: clip }` in the 767px media query; verified home/category/product/contact/checkout all sw==cw; drawer open/close still works | `css/material.css` (mobile section) |

## Other pages / responsive / misc

| Requirement | Notes / acceptance criteria | Files to change |
|-------------|----------------------------|-----------------|
| | | |

---

## Change log

| Date | Change | Files touched |
|------|--------|---------------|
| 2026-08-05 | Initialized guide + client requirements docs; deployed local instance | `docs/`, deployment artifacts |
| 2026-08-05 | Rebuilt theme header/footer/index + custom CSS; removed all QloApps/Webkul/"Hotel Prime"/"Demo City" branding (front + admin); generated farmhouse logo + favicon; rewrote About Us / testimonials / hotel description; admin login/dashboard/footer de-branded | `themes/my-farmhouse-child-theme/{header,footer,index}.tpl`, `css/custom.css`, `product.tpl`, `history.tpl`, `modules/blockcart/blockcart.tpl`, `hotel-admin/themes/default/template/{header,footer}.tpl`, `controllers/login/{content,header}.tpl`, `controllers/dashboard/helpers/view/view.tpl`, `img/{logo,logo-login}.png`, `img/favicon.ico`, DB rows in `qlo_htl_branch_info_lang`, `qlo_meta_lang`, `qlo_cms_lang`, `qlo_category_lang`, `qlo_address`, `qlo_configuration`, `qlo_htl_testimonials_block_data(_lang)` |
| 2026-08-05 | M3 foundation: tokens, components, rebuilt app bar / footer / custom.css / material.css / material.js; fixed `@import` loading (custom.css + material.css now linked, since browsers ignore trailing `@import`); fixed app-bar sticky (`.site-header.is-home > *` was overriding position); search form theme override (`.m3-field` labelled fields + icons) with higher-specificity button/input rules; fixed mobile nav drawer (overlay forced visible by `.app-nav > div`; stopPropagation on `.nav_toggle`); verified all interactions + computed styles via headless Chrome | `themes/my-farmhouse-child-theme/{header,footer}.tpl`, `css/{custom,material}.css`, `js/material.js`, `themes/my-farmhouse-child-theme/modules/wkroomsearchblock/views/templates/hook/{searchForm,landingPageSearch}.tpl` |
| 2026-08-06 | Phase B: M3 room cards on category page (16px cards, Playfair headings, primary prices, Filled Book Now), M3 product detail + booking form (`#image-block`, `.pb-right-column` card, `button.exclusive` Filled, 48px fields, primary total) — verified via headless Chrome | `css/material.css` |
| 2026-08-06 | Phase C: M3 checkout (accordion cards, room-summary lines as cards, totals card, `.room_duration_block`), M3 `#layer_cart` add-to-cart confirmation (16px + elevation-3, outlined Continue / Filled Proceed), auth/account/identity/address `.box` cards, contact form card + Filled button, payment-block/`.payment_module` option styles, global mobile `overflow-x: clip` fix; **DB fixes approved by client**: created missing `qlo_newsletter` table (blocknewsletter 500'd registration), inserted missing default currency INR id=1 (no prices rendered / payment failed) | `css/material.css`, `qlo_newsletter`, `qlo_currency` |
| 2026-08-07 | Recorded expanded scope: 250 rural-UP properties, home-page Activities tab, mobile-first, caretaker SMS/email and Razorpay (UPI/RuPay); opened QloApps-vs-custom decision | `docs/CLIENT-REQUIREMENTS.md` |
| 2026-08-07 | Client selected QloApps; activities clarified as informational-only content (no activity inventory/cart/booking). Implemented and verified Apache + PHP 8.3 + MariaDB 10.11 Compose development stack; Rocky Linux VPS deployment deferred until later | `Dockerfile`, `docker-compose*.yml`, `docker/`, `scripts/backup.sh`, `docs/DEPLOYMENT-REDHAT.md` |
| 2026-08-08 | **Farmhouse redesign** (replaces M3): design-system.css tokens + Fraunces/Manrope self-hosted fonts; rebuilt header/footer shell; homepage hero + trust strip + section grids; search bar restyle (5 module overrides); category/our-properties room cards; room detail with sticky booking widget; one-page checkout restyle; account/confirmation/detail/auth/contact/cms/stores/404/guest-tracking overlays; account.css added (fixed header.tpl 404). Verified no overflow 375/768/1440, no console errors; full guest journey placed 2 real orders. **DB repair (client-approved):** `qlo_currency_shop` + `qlo_module_currency` (bankwire/cheque) rows so payment methods render | `themes/my-farmhouse-child-theme/` (design-system.css, components.css, home.css, product_list.css, product.css, order-opc.css, account.css + per-page overlays, header/footer/index/category/product .tpl, module search overrides, fonts), `qlo_currency_shop`, `qlo_module_currency` |
| 2026-08-12 | **Rural discovery platform planned (plan `rural-discovery-platform`, spec `farmstay-discovery`)**: client confirmed clean-modern (Airbnb discipline), refined farmhouse palette, HYBRID imagery (royalty-free photos for hero/regions/blog ONLY + monogram SVG placeholders for property cards — supersedes premium-home-pass media item), scope = home + rooms + booking + new regions/activities/blog discovery surfaces. New modules: `fhregions` (managed UP regions, seeded Bundelkhand/Awadh/Braj/Purvanchal/Rohilkhand/Kashi) and `fhblog` (admin CRUD + seeded posts); activities informational-only (never in cart). English-first, i18n-ready. Discovery layer only — no wkroomsearchblock surgery. Research extended in `docs/RESEARCH-COMPETITORS.md` (Airbnb DLS, UP gov farm-stay policy 2025, typography-first adaptation) | `docs/RESEARCH-COMPETITORS.md`, `docs/CLIENT-REQUIREMENTS.md`, `docs/plans/rural-discovery-platform.md`, `docs/specs/farmstay-discovery.md` |
