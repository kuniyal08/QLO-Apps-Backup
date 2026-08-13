# Spec: Story-Media-QA

Scope: feature

# Farmstay Story Media + Search Panel Responsive Spec

## Story covers (fhblog home teaser)

- All four seeded demo posts ("A night on a Bundelkhand farm", "Village guide: Chanderi's weaving country", "Five farm activities you can actually join", "Understanding UP's farm stay policy") must have a cover.
- Covers are DB filenames in `fhdiscover_blog_post.cover`, rendered from `_PS_IMG_/fhblog/<file>` (site root `/img/fhblog/`), resized 1200x675 (16:9) — matching the admin upload contract.
- Sources must be free-license (CC0/CC BY/CC BY-SA/PD) with author + license + source URL recorded in `docs/RURAL-UP-MEDIA.md`; files self-hosted under `themes/rural-up-theme/img/editorial/story-*.jpg` (theme) and `/img/fhblog/` (served, seeded).
- Subject mapping: Bundelkhand night post → night/farm scene; Chanderi weaving post → loom/weaving image; farm activities post → farm-activity scene; farm stay policy post → rural farmhouse scene.
- Seeder contract: new `seedStoryCovers()` idempotent by default (only fills empty covers), `--refresh-images` re-copies + re-sizes from editorial; failure tolerated (never blocks property seeding); copied via PHP image pipeline (copy+resize), not raw file writes to web root.
- Newsletter/template: no change needed — `home-teaser.tpl` already renders `{if $post.cover}` → `<img src="{$smarty.const._PS_IMG_}fhblog/{$post.cover}">` with letter fallback.

## Occupancy dialog on category-page search panel

- Renders inside `#left_column` (col-sm-3) via `hookDisplayAfterHookTop`; module JS contract (`#search_occupancy_wrapper` Bootstrap dropdown, `.occupancy_count`, `.qty_direction`, `submit_occupancy_btn`, `add_new_occupancy`) must stay byte-identical.
- Desktop: dialog width must fit the panel column (not overflow the page), rows use full dialog width, stepper buttons and counts legible.
- Mobile (<768px): dialog must be full panel width (or full viewport minus gutter), never clipped horizontally, height should not exceed viewport when open (scrollable inside if needed).
- The homepage panel dialog (`.header-rmsearch-container #search_occupancy_wrapper`) must keep current styling.

## QA gate (desktop + mobile)

- No horizontal overflow: `document.documentElement.scrollWidth <= window.innerWidth` on homepage, category, region list/detail, our-properties, product, blog list/detail.
- All images on rendered pages load (HTTP 200 / `complete && naturalWidth > 0`).
- No console errors on any route at any tested viewport; server logs clean of new warnings after fixes.
- Flows verified in-browser: open occupancy dialog → set adults → Done; pick quick dates; submit search → results page renders; sticky panel toggle on mobile shows/hides form.
- Tested viewports: 1440x900 (desktop), 768x1024 (tablet), 390x844 (mobile).