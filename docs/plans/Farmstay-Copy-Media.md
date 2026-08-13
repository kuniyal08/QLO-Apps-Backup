---
plan name: Farmstay-Copy-Media
plan description: Rural theme content polish round
plan status: done
---

## Idea
Polish the Rural UP presentation MVP: (1) fix the category-page search panel that renders inside the narrow left column and overflows its 5-column grid over the "Available stays" heading area; (2) rewrite the four "Book with confidence" feature cards (currently hotel copy: Luxurious Rooms / World class chefs / Restaurants / Gym & Spa) into farmstay-appropriate content stored idempotently via the demo seeder, with new SVG sprite icons; (3) replace the generic Westerh-Kun Splash-derived region covers and property covers with authentic Indian imagery sourced from Wikimedia Commons (Bara Imambara for Awadh, Orchha for Bundelkhand, Varanasi ghats for Kashi, mango groves, Banarasi looms, etc.) with license/attribution recorded in the media manifest; (4) extend the seeder to refresh demo media (region covers + hotel images) so the swap is repeatable; (5) update docs and run route/log QA. No booking engine, core, or module-logic changes; only theme templates/CSS, sprite symbols, media files, seeder data, and docs.

## Implementation
- Fix category-page search panel bleed: add Rural UP CSS scoping #category #left_column .fh-search-panel--sticky to stack the fh-search-grid vertically (block fields, full-width date/guests areas, submit button full width, no overflow) and tidy #left_column layered filters; verify via fetched DOM that the panel no longer overflows the col-sm-3 width over the center-column 'Available stays' hero.
- Clear stale Smarty compile cache (host cache/smarty/compile, bind-mounted) so categoryPageSearch.tpl.php regenerates with the {$id_hotel|default:0} guard; confirm the Undefined array key 'id_hotel' / Attempt to read property 'value' on null warnings disappear from podman logs.
- Add idempotent feature-block sync: extend scripts/seed-rural-up-demo.php with a syncFeatureBlocks() that updates the 4 rows of htl_features_block_data (en + fallback for other languages) to farmstay copy (Farmstay rooms / Home-style UP kitchen / Local experiences / Clear, easy booking with short descriptions), then run the seeder in the web container.
- Add card visual system: append ru-icon-bed, ru-icon-food, ru-icon-compass, ru-icon-shield symbols to themes/rural-up-theme/img/rural-up-icons.svg and update themes/rural-up-theme/modules/wkhotelfeaturesblock/views/templates/hook/hotelfeaturescontent.tpl to render the sprite icons instead of the ✓/₹/⌂/✦ glyphs, with matching .ru-benefit icon styling in rural-up.css.
- Source Indian imagery from Wikimedia Commons: for each region cover (Awadh→Bara Imambara Lucknow, Bundelkhand→Orchha palace, Braj→Mathura/Vrindavan temple, Purvanchal→Ayodhya Ram Mandir, Rohilkhand→Pilibhit Tiger Reserve landscape, Kashi→Varanasi ghats) and each property cover (mango grove, Orchha courtyard, Yamuna/temple courtyard, Sarayu fields, terai grassland, Banarasi silk loom), query the Commons API, verify license (CC0/CC BY/CC BY-SA) and capture author+source URL, download best-resolution candidates.
- Prepare media assets: resize downloaded originals into themes/rural-up-theme/img/editorial/ (property covers 4:3, ~1600px wide; region covers 1600x900 as demo-region-{slug}.jpg) using ImageMagick or PHP GD; keep filenames of existing demo-*.jpg where the seeder references them.
- Extend seeder for media refresh: replace/sync region cover writes (currently _PS_IMG_DIR_.'fhregions/') with the new images and add a --refresh-images mode that re-uploads hotel cover/gallery images for demo properties when the editorial source changed (hash compare) — then podman cp the updated seeder into the container and run it with the refresh flag.
- Update documentation: rewrite docs/RURAL-UP-MEDIA.md with the full new media table (region + property, subject, author, license, source URL) and update docs/RURAL-UP-DEMO-PROPERTIES.md for the new feature-card copy and the --refresh-images reseed instructions.
- QA: verify homepage feature section renders new copy+icons, category page (id_category=15 with date_from/date_to/occupancy params) shows a contained left-column search panel with no overflow, region list + region detail serve the new covers (HTTP 200 on /img/fhregions/*.jpg), product page unaffected, php -l clean on seeder, and web logs free of the previous warnings.

## Required Specs
<!-- SPECS_START -->
- Rural-Editorial-Spec
<!-- SPECS_END -->