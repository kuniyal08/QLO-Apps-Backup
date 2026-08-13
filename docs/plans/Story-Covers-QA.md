---
plan name: Story-Covers-QA
plan description: Story images and responsive fixes
plan status: active
---

## Idea
Three-part polish round on the Rural UP demo frontend: (1) The homepage "Stories worth taking your time with" section (fhblog home-teaser) currently renders letter-tile fallbacks for all 4 seeded posts because none have covers. Populate each post's DB cover (img/fhblog/<file>.jpg, 1200x675) with appropriate licensed imagery via an idempotent seeder addition that copies from the theme editorial dir (self-hosted, attribution recorded in RURAL-UP-MEDIA.md) — "A night on a Bundelkhand farm" (night/farm scene), "Chanderi's weaving country" (loom image), "Five farm activities" (farm activity scene), "UP's farm stay policy" (rural farmhouse scene). (2) The occupancy dialog (#search_occupancy_wrapper dropdown-menu) on the category-page search panel renders at the wrong size — the theme styles it only inside .header-rmsearch-container (homepage), so on category pages inside #left_column it falls back to Bootstrap dropdown-menu sizing. Characterize with real browser measurements then fix with scoped CSS for both desktop (inline dropdown) and mobile (full-width dropdown). (3) Full browser QA on desktop + tablet + mobile using a local Playwright+Chrome harness (playwright-core + /bin/google-chrome): homepage, category search flow (open occupancy dialog, dates, submit), region list/detail, our-properties, product page, blog list/detail, footer/bottom-nav; assert no horizontal overflow, working sticky toggle, images load, no JS errors; fix everything found.

## Implementation
- Set up local browser QA harness: npm i playwright-core in /tmp/opencode/pwtest, launch /bin/google-chrome headless; write reusable script that screenshots + reports body scrollWidth/clientWidth, element bounding boxes, image load failures, console errors for a given URL+viewport
- Baseline QA: run harness on homepage, category page (id_category=19 with dates/occupancy), region list/detail, our-properties, product, blog list/detail at 1440x900, 768x1024, 390x844; characterize the occupancy dropdown bounding box on category page (desktop + mobile) and list all layout bugs
- Source story imagery: attempt Commons downloads for night-farm, farm-activity, rural-farmhouse scenes (429 backoff); fall back to reusing existing licensed editorial assets; reuse silk-looms original for the Chanderi weaving post; prepare 4 x 1200x675 JPEGs into themes/rural-up-theme/img/editorial/story-*.jpg
- Extend seeder with seedStoryCovers(): idempotent (skip if cover set; --refresh-images re-copies), resizes/copies each story-*.jpg into _PS_IMG_/fhblog/, updates fhdiscover_blog_post.cover by slug; podman cp + run; verify homepage story cards render <img> with the 4 covers
- Fix occupancy dialog sizing on category page: scoped CSS for #category #left_column .fh-search-field--guests .dropdown and #search_occupancy_wrapper (desktop: width relative to panel field; mobile: full-width dropdown below the field); measure post-fix bounding boxes with harness
- Desktop QA pass: re-run harness on all routes at 1440x900; verify search flow end-to-end (occupancy dialog ok, dates ok, submit 302 to results, results cards); fix any remaining issues
- Mobile/tablet QA pass: re-run at 390x844 and 768x1024; verify sticky panel toggle, occupancy dialog, datepicker, overflow 0, bottom-nav; fix anything found
- Final sweep: podman logs clean scan, update docs (RURAL-UP-MEDIA.md story rows + seeder docs), save final screenshots for user eyeball, php -l seeder

## Required Specs
<!-- SPECS_START -->
- Story-Media-QA
<!-- SPECS_END -->