# Spec: premium-search-hero

Scope: feature

# Spec: Premium Search Bar, Hero & Media System

Scope: feature. Companion to plan `premium-home-pass`. Extends the farmhouse design system (spec `farmhouse-design-system`) with competitor-validated premium patterns for the homepage search bar, hero integration, icon system and media sourcing.

## 1. Design Evidence (research digest — full record in docs/RESEARCH-COMPETITORS.md)

| Site | Search-bar pattern | Why it feels premium |
|------|--------------------|----------------------|
| Booking.com | Single horizontal white bar; 4 inputs (destination, grouped date range, occupancy counter "2 adults · 0 children · 1 room", CTA); fields are segments separated by hairline dividers; small label above each value; tinted field fill; "I'm flexible" + trust line under the bar | Grouped control (one task), generous padding (Fitt's law), highest luminance contrast, scarce text, single hero image (eye-tracking favorite, Baymard) |
| Airbnb | Compact pill bar: "Anywhere \| Any week \| Add guests" segments + circular brand-color magnifier button; clicked segment expands into popover; default = flexible | Reduced required fields, one clear high-contrast CTA, hairline segment separators |
| MakeMyTrip / Agoda / Expedia | Same 4-field schema in white rounded box; MMT criticized for clutter (case studies) | Restraint = premium; one primary CTA |
| A/B evidence (GoodUI) | Single search bar beats two; single-line bar with minimal inter-field padding beats multi-line; exposing adults/children/rooms counts in the bar won; location tiles higher = better | — |

### Cheap-vs-premium heuristics (from audits)
1. Separate boxed fields with gaps = dashboard form; grouped single control with dividers = premium product.
2. Whitespace: let content breathe; consistent 8px spacing rhythm; consistent radii/shadows (few-pixel drift reads as cheap).
3. One neutral base + 1–2 accents used sparingly; mixed icon styles = chaos.
4. Typography: one display + one body font, generous sizes, tuned line-height, no uppercase-12px labels for primary inputs.
5. Micro-interactions: hover/focus states, motion only on transform/opacity, reduced-motion guard.
6. Contrast: WCAG AA (4.5:1 body, 3:1 large); focus-visible rings everywhere.

## 2. Search Bar Spec (Booking-style single bar)

Surface: `#search_hotel_block_form` inside `.fh-search-panel` (hero on index, sticky on category/room pages, fancybox modal `#xs_room_search_form` on mobile). **Contract invariants (MUST NOT change):** form id/action, field ids+names (hotel_location, location_category_id, check_in_date, check_out_date, adult_count, child_count, number_of_rooms, search_room_submit), classes (header-rmsearch-input, input-date, daterange_value_from/to, guest_occupancy, occupancy[] hidden inputs), hooks displaySearchFormFieldsBefore/After, datepicker JS on .input-date, Bootstrap data-toggle dropdown on #guest_occupancy, autocomplete on #hotel_location.

Layout:
- Desktop (>=1200): one row — [Destination | Check-in | Check-out | Guests+Rooms | Search pill]. Container: white, radius-lg (20px), layered soft shadow (elevation search-panel token). Segments divided by 1px hairline (rgba ink .08), no gaps between segments. Each segment: small sentence-case label (13px, muted) above a value line (16px, ink, medium weight), field fill transparent; hover/focus segment gets tinted fill (rgba cream/forest .06) + 2px forest focus ring inset.
- Tablet (768–1199): 2-row grid — location full-width, then dates + guests, CTA full-width.
- Mobile (<768): stacked full-width segments with >=44px touch targets; date fields open the existing datepicker; guests opens occupancy dropdown; CTA full-width primary; inside fancybox modal with 16px padding.
- Quick-date chips: slim row under the bar (desktop) labelled "Quick dates"; chips = 32px pill, primary text, hover fill; mobile keeps chips.
- Trust line: under the bar on the homepage hero only: "Free cancellation · Direct booking · No hidden fees" (13px, muted; source: existing trust strip copy).

## 3. Hero Spec (Booking-style integration)

- Panel overlaps the hero image (lower third), NOT pinned under the header; implemented by adjusting `#index .fh-hero` margin-top and panel z-index/negative margin — hero top edge slides under the panel as today but the panel visually sits on the image.
- Title: Fraunces display, clamp(40px, 5.5vw, 64px), line-height 1.1, weight 600, white, max-width 720px; optional eyebrow (12px, letter-spacing .18em, uppercase, white .8) above title using WK_* copy.
- Subtitle: 16/26 white .92 max-width 560px.
- Gradient: `linear-gradient(180deg, rgba(31,27,22,0) 40%, rgba(31,27,22,.72) 100%)` for legibility over any image.
- Header stays transparent over hero; `.fh-header-sticky .fh-header` translucent cream on scroll (unchanged).
- Mobile: panel stacks below the hero title; hero min-height ~560px; existing mobile pill (`landingPageXsBtn`) unchanged.

## 4. Icon System Spec

- Source: one MIT/ISC stroke set on 24x24 grid, 2px stroke, `currentColor` — recommend **Tabler Icons** (largest coverage, MIT) or **Lucide** (strictest consistency, ISC); pick ONE, never mix.
- Delivery: self-hosted inline SVG sprite or CSS mask layer, ~20–30 icons max, subset only (search, calendar, users, bed, leaf, home, phone, shield-check, tag, location-pin, chevron-down, close, menu, star, wifi, heart, clock, rupee, check, arrow-right, facebook/instagram brands if used). No external CDN.
- Replace ALL mixed FontAwesome icons in farmhouse components (trust strip, nav, footer, contact, 404) with the sprite.
- Include the set's LICENSE file in the theme directory; total added payload < 15KB gz.

## 5. Media System Spec

- Sources: Unsplash License / Pexels License — free commercial use, no attribution required; **avoid recognizable people (no model releases) and trademarked buildings**; self-host downloaded files in the `img` volume (entrypoint seeds from /usr/local/share/qloapps-media/img/), never hotlink.
- Curate 4–8 images (hero 16:9 >=1920w, interiors, amenities, rooms, testimonial bg) fitting the rural-UP farmhouse brand (mud-courtyard craft, harvest fields, verandas, local hospitality).
- Config to update (client-approved values): WK_HOTEL_HEADER_IMAGE, WK_TITLE_HEADER_BLOCK ("rural stays and local stories" direction), WK_CONTENT_HEADER_BLOCK; demo images kept as fallback.
- Performance: below-fold images `loading="lazy"` where templates allow; keep hero as the only above-fold photo.

## 6. Shared-Component Polish Spec

- Buttons: pill radius, min-height 44px, hover lift `translateY(-1px)` + shadow, `:focus-visible` 2px ring; primary forest green, accent terracotta for secondary highlights only.
- Cards: uniform radius-md (12px) default, radius-lg (20px) for hero/search; layered shadows from tokens.
- Forms: 48px min-height fields, tinted fill, 2px primary focus ring (already partially done — make consistent).
- Type: body 16/26; section headings Fraunces display with restrained letter-spacing; remove uppercase-12px labels on primary inputs (sentence case 13px).
- Motion: transform/opacity only; `@media (prefers-reduced-motion: reduce)` disables transitions.
- Efficiency: added JS 0 new libs; added CSS/JS stays within farmhouse targets (<25KB gz JS, <30KB gz added CSS).

## 7. Acceptance Criteria

- `docs/RESEARCH-COMPETITORS.md` exists with competitor patterns, heuristics, icon comparison, media licensing, and source URLs.
- Homepage search bar renders as a single rounded bar on desktop (segments + dividers + one CTA), 2-row tablet, stacked mobile — with NO changes to any field id/name/class/hook; datepicker, occupancy dropdown, autocomplete and search submit all still work (regression walk: home → category → product → cart).
- Hero title scales (clamp), panel overlaps image, trust line present; no horizontal overflow at 375/768/1440; touch targets >=44px; no console errors.
- One consistent stroke icon set replaces mixed icons; LICENSE included; <15KB gz added.
- Curated royalty-free images installed in the img volume + config updated; demo fallback intact.
- Weight audit recorded; caches cleared; atomic Conventional Commits on feature/rural-marketplace-alpha; docs (PROJECT-GUIDE, CLIENT-REQUIREMENTS) updated.