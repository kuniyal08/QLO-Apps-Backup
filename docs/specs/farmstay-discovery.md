# Spec: farmstay-discovery

Scope: feature

# Spec: Farmstay Discovery Platform (fhregions, fhblog, activities, typography-first redesign)

Scope: feature. Companion to plan `rural-discovery-platform`. Extends the farmhouse design system (spec `farmhouse-design-system`) and the journey spec `Rural-Frontend`.

## 1. Confirmed decisions (client)

| # | Decision | Choice |
|---|----------|--------|
| D1 | Direction | Clean modern, Airbnb discipline: restraint, one typeface for display, ONE accent reserved for primary actions, soft radii, whitespace-led depth. |
| D2 | Palette | Refine the farmhouse palette, keep it: forest green #2F4A3C primary on cream #F7F4EF; terracotta #C46A3B secondary highlight only. |
| D3 | Imagery | HYBRID: real royalty-free photos (Unsplash/Pexels) for the hero + ambient/editorial surfaces (clearly decorative, never claiming a specific property); designed monogram/color-block SVG placeholders for property cards and any surface that would misrepresent a specific stay. |
| D4 | Scope order | Home + rooms + booking first, then regions/activities/blog discovery surfaces. |
| D5 | Blog | Dedicated module `fhblog` with admin CRUD (title, slug, excerpt, content, category, cover, date, author, active, meta) + seeded sample posts. |
| D6 | Regions | Managed module `fhregions` (name, slug, blurb, description, cover, active, position) + seeded ~6 UP regions: Bundelkhand, Awadh, Braj, Purvanchal, Rohilkhand, Kashi. |
| D7 | Language | English-first, i18n-ready: every string through translation methods per AGENTS.md (no hardcoded English); Hindi wrapping safe (no fixed-width overflow). |
| D8 | Discovery | Discovery layer only: region cards, activity chips, stay+do bundles linking into existing search/listing pages with pre-applied filters where supported. NO surgery on wkroomsearchblock. |
| D9 | Government positioning | Platform presents as the booking face of the UP farm-stay initiative (Farm Stay investment drive 2025, B&B/Homestay Policy 2025): trust-led, editorial, government-property friendly. |
| D10 | Reconciliations | Supersedes the photo-media work item of plan `premium-home-pass` (its icon-system + trust/conversion items stay). Keeps the preserved-contract invariants of `Rural-Frontend` and `farmhouse-frontend-redesign`. |

## 2. Imagery system (hybrid)

- Sources: Unsplash License / Pexels License (commercial, no attribution). AVOID recognizable faces (no model releases) and trademarked buildings.
- Delivery: download into `themes/my-farmhouse-child-theme/img/` (bind-mounted -> survives container recreate; avoids the img-volume seed path). NEVER hotlink CDNs at runtime.
- Scope of real photos (~10-15, curated rural-UP style): hero (>=1920w 16:9), region covers (6), blog covers (3-5), ambient editorial blocks. Each resized/compressed (target <=250KB each, WebP optional w/ JPEG fallback).
- Property cards (our-properties, category, product gallery, home room grid): designed SVG placeholders — monogram of room/property name on a color-block (cream/sage/terracotta tint cycle), hairline border, optional small icon glyph. These read as intentional, not cheap.
- Swap path: document in docs/PROJECT-GUIDE.md + docs/RESEARCH-COMPETITORS.md how a real property photo replaces a placeholder (file name convention per room id, e.g. room_{id}.jpg) — no template change required at swap time.
- Hero image served via template/CSS from the theme dir; do NOT rely on WK_HOTEL_HEADER_IMAGE img-volume config for the new hero (kept as fallback).

## 3. Module contract: fhregions

- Mirror the `ruralactivities` module pattern (classes/, controllers/front/, admin controller, config.xml, install()/uninstall() with Configuration keys prefixed `FHDISCOVER_`).
- Model `FhRegion`: fields as D6 + timestamps; multi-language strings via id_lang (per AGENTS.md multi-language rule); slug unique.
- Front controllers: `region.php` (listing, paginated 12, active only, position order) and `region-detail.php` (blurb, description, cover, linked farmstays, linked activities, adjacent regions). URLs via `getModuleLink('fhregions', ...)`.
- Farmstay linkage: store `id_hotel` (and/or product ids) in a link table `_DB_PREFIX_fhdiscover_region_hotel` — join to hotel/room data via existing core models/helpers (no SQL contract changes to core tables).
- Activity linkage: link table to ruralactivities activity ids; region detail lists them; activity detail shows "found in region X".
- Admin: listing + edit forms with image upload (existing PrestaShop upload helpers), active/position toggles, sortable.
- Hooks: `displayRegionList` (homepage region preview strip, called from theme template), `displayHome` contributions via template overrides; keep hook handlers lightweight.

## 4. Module contract: fhblog

- Model `FhBlogPost`: id_post, title (id_lang), slug, excerpt (id_lang), content (id_lang), id_category, cover image, date_add, active, author (id_lang), meta_title/meta_description (id_lang).
- Category: lightweight enum/table `_DB_PREFIX_fhdiscover_blog_category` (name id_lang) seeded: Farmstay Stories, Village Guides, Activities, Government & Policy.
- Front controllers: `blog.php` (listing, paginated 9, category filter param) + `blogpost.php` (detail with excerpt/cover/content, prev/next, related posts by category).
- Admin: full CRUD with PrestaShop helper forms; slug auto-generated from title; cover upload.
- Seed data: 3-5 posts in the brand voice (farmstay story, village guide, activity feature, farm-stay policy explainer, region spotlight).

## 5. Activities expansion (informational only)

- `ruralactivities` module logic UNTOUCHED. Add theme template overrides + css only.
- Activities NEVER enter inventory, cart, checkout, or payment (hard invariant from Rural-Frontend).
- New surfaces: homepage chips strip (categories/featured), region-detail activity list, "stay + do" bundle cards on activity detail linking to existing availability search with pre-applied location/dates where the platform supports it.

## 6. Design system additions (typography-first, hybrid imagery)

- Tokens in css/design-system.css: extend type scale (hero clamp(40px,5.5vw,64px) Fraunces 600; section headers Fraunces; body Manrope 16/26), spacing 8px rhythm, radii 8/12/20/pill, elevation (hairline dividers > shadows), accent usage rule (forest green = primary action only; terracotta = secondary highlight; support sage/harvest-gold).
- Surfaces: color-block cards (monogram covers), editorial photo blocks (real photos only on ambient/editorial), hairline-bordered groups, section eyebrow labels (12px, letter-spacing .18em, uppercase).
- Components: buttons (pill, min-height 44px, hover lift, focus-visible ring), chips, badges (review score, price-per-night, free-cancellation), section headers, trust line, footer columns, empty states.
- Motion: transform/opacity only; `prefers-reduced-motion: reduce` guard. No new JS libraries (vanilla only).
- Per-page css convention: css/home.css, css/discover.css (regions/activities), css/blog.css, css/product_list.css, css/product.css additions.

## 7. Preserved contracts (MUST NOT change)

- All wkroomsearchblock field ids/names/classes, hooks (displaySearchFormFieldsBefore/After), datepicker/dropdown/autocomplete JS contracts.
- All QloApps core + module hooks per the farmhouse-design-system hook inventory; cart/checkout templates only restyled as already shipped, no logic change.
- Search -> availability -> room -> occupancy -> cart -> checkout -> confirmation flows unchanged.
- Translation methods per AGENTS.md table; core templates use {l s=''}, modules use $this->l(); new module front controllers use `$this->module->l('string','controllerName')`.

## 8. Content + seed data

- fhregions: 6 regions with blurb/description/cover (placeholder art where no photo used).
- fhblog: 3-5 posts.
- Activities: use existing seeded activities; add region linkage seeds.
- Navigation IA: Home, Farmstays, Regions, Activities, Stories, Contact (blocknavigationmenu links + drawer + footer explore section).

## 9. Acceptance criteria

- Home, region list/detail, activities, blog list/detail, our-properties, category, product, cart render without horizontal overflow at 375/768/1440; 44px touch targets; no console errors; keyboard-accessible; contrast WCAG AA.
- Real photos appear only on hero/region/blog/ambient surfaces; property cards use monogram placeholders; swap path documented.
- Full booking regression passes with preserved hook/field/JS checklist.
- No hardcoded user-facing English in new templates/modules; Hindi-safe wrapping.
- fhregions + fhblog installable/seedable via install scripts; admin CRUD functional.
- Caches cleared (smarty + class_index); atomic Conventional Commits on feature/rural-marketplace-alpha; docs (RESEARCH-COMPETITORS, PROJECT-GUIDE, CLIENT-REQUIREMENTS) updated.

## 10. Non-goals

- No booking/pricing/availability backend changes; no new core hooks; no wkroomsearchblock surgery; no cart/checkout logic changes.
- Razorpay/SMS/OTP/caretaker modules remain separate workstreams.
- No real property photography this phase (that is client-provided later; placeholders are designed to swap).