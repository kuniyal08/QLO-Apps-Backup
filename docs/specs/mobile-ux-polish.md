# Spec: mobile-ux-polish

Scope: feature

# Rural UP Mobile UX & Frontend Polish

Feature scope for the QloApps Rural UP demo theme (`themes/rural-up-theme`). Theme-only changes; no core/module PHP edits.

## Verified defects (Chrome + Playwright, 375px & 1440px)

| Defect | Root cause |
|---|---|
| Hero search bar invisible on mobile homepage | `landingPageSearch.tpl` container has bootstrap `hidden-xs`; the "Search stays" pill (`landingPageXsBtn.tpl`) exposes a raw inline form |
| Two menu buttons on mobile header | Working module hamburger `.nav_toggle` + dead `a.ru-mobile-nav` (`href="#footer"`, header.tpl:121) |
| Slide-in menu cheap; X misplaced | Module default `#menu_cont` sheet; `.close_navbar` is a 50x50 green box whose `icon-close` glyph never loads (renders blank) |
| Category/search results page misaligned (all viewports) | `categoryPageSearch.tpl` calls `{hook h='displayFhHotelRating' id_hotel=$id_hotel|default:0}` with no hotel -> `.fh-rating-strip` renders ~1600px tall because star CSS + sprite are missing (SVGs at default 300x150) |
| "Things to do in Bundelkhand" (region detail) colouring off | Global `header{background:#fff}` rule paints every `<header class="ru-section-head">` white; homepage fix was scoped `#index .ru-section-head{background:transparent!important}` only |
| Blog grid misaligned; "Five farm activities" card image bleeds/half-hidden (desktop + mobile) | `.fh-blog-grid` tracks blow out to 640px because grid items' images keep intrinsic 640px min-content (`img` lacks `width:100%`); plus the `fh-*` component layer (CSS custom props `--fh-*`, `.fh-card`, `.fh-container`, `.fh-ic` sizing, inline sprite `#fh-ic-star`/`#fh-ic-arrow-right`) is missing from the theme |
| Horizontal overflow on mobile (region1 390px, regions 390px, our-properties 393px, category 405px, product 405px vs 375px; product 1455px vs 1440px desktop) | Bootstrap `.row` negative margins + `.col-*` padding in full-bleed `#columns` on non-index pages |

## Design template (Rural UP system)

- Cream paper page bg `--ru-paper`, ink text `--ru-ink`, white cards `--ru-white`, hairlines `--ru-line`, sage `--ru-sage` (#edf1e9)
- Green primary `--ru-green` (#315e45), dark hover `--ru-green-dark`, clay accents `--ru-clay`, muted `--ru-muted`
- Fonts: RuDisplay (serif display), RuSans (body); eyebrow = clay 11px uppercase letterspaced
- Radii 14-22px, soft shadow `--ru-shadow`, generous section rhythm (58-88px)

## Requirements

1. **Mobile hero search (home)**: search panel visible in-flow under hero copy on <768px; remove redundant mobile pill; hero padding / columns padding rebalanced so nothing overlaps; desktop unchanged.
2. **Single menu button**: delete `a.ru-mobile-nav` + its CSS; only `.nav_toggle` hamburger remains.
3. **Menu redesign**: theme override of `navigationMenuBlock.tpl` (keep JS contract: `.nav_toggle`, `#menu_cont`, `.menu_cont_left/right` classes, `.close_navbar`, `.navigation-link`, `$navigation_links`, `displayDefaultNavigationHook`/`displayExternalNavigationHook`). Flex header row: serif "Rural UP" brand + close X using `ru-icon-close` sprite, aligned top-right, 40px touch target; eyebrow "Explore"; large serif links with hairline separators; footer help link. Styled in `rural-up.css`.
4. **Category page**: only render rating hook when `$id_hotel` set; results toolbar follows the Modify-search panel; no horizontal scroll; mobile search toggle + occupancy bottom sheet keep working.
5. **Region pages**: `ru-section-head` transparency rule un-scoped from `#index` to all pages (also `.fh-page-head`); sage "Local rhythm" band shows correct colouring.
6. **Blog**: grid tracks `minmax(0,1fr)`, card media `img{width:100%;height:auto}`, restore missing `fh-*` component layer (custom props mapped to ru tokens: `--fh-primary`, `--fh-card`, `--fh-border`, `--fh-muted`, `--fh-text`, `--fh-ink`, `--fh-radius-*`, `--fh-font-display`/`--fh-font-base`; base styles for `.fh-container`, `.fh-section`, `.fh-card`, `.fh-card__media`, `.fh-eyebrow`, `.fh-tag`, `.fh-ic` sizing, `.fh-filter-*`, `.fh-pagination`); inline SVG sprite in footer.tpl with `#fh-ic-star`, `#fh-ic-arrow-right` (+ any other `fh-ic-*` referenced by fhblog/fhreviewbadge templates); star overlay mechanics for `.fh-stars` (two rows, fill width driven by `--fh-score`).
7. **Overflow sweep**: mobile rows/columns reset so bodyScrollW == viewport width on region detail, regions list, our-properties, category, product; fix residual 15px desktop overflow on product page.
8. **Verification**: re-run DOM measurement suite at 375/1440 for bodyScrollW, section-head backgrounds, grid column sizes, strip height, menu panel geometry (X at top-right, panel slide), hero search visibility; also verify homepage unchanged.

## Verification page set

- `/` (home, reference — must not regress)
- `/index.php?fc=module&module=fhregions&controller=regiondetail&id_region=1`
- `/index.php?fc=module&module=fhregions&controller=region`
- `/index.php?controller=our-properties`
- `/index.php?fc=module&module=fhblog&controller=blog` (+ a blogpost)
- `/index.php?id_category=21&controller=category&date_from=2026-08-21&date_to=2026-08-23&occupancy[0][adults]=1&occupancy[0][children]=0&location=20`
- `/index.php?id_product=14&controller=product&date_from=2026-08-21&date_to=2026-08-23&occupancy[0][adults]=1&occupancy[0][children]=0&location=20`