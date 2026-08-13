# Spec: Rural-Editorial-Spec

Scope: feature

# Rural UP Editorial Content Guidelines

Reusable rules for all guest-facing copy and media produced for the Rural UP QloApps demo (themes/rural-up-theme + demo seed data).

## Copy voice
- Farmstay-first: verandas, orchards, fields, village mornings, home-style kitchens, local hosts. Never hotel luxury language (no "world-class", "5-star", "state-of-the-art gym").
- Concrete and specific: name the place (Malihabad mango groves, Awadh, Bundelkhand, Sarayu), the experience (thali dinners, heritage walks, handloom looms), and the booking promise (transparent prices, instant confirmation, local support).
- Short: card titles <= 3 words; descriptions <= 25 words; plain English, no puffery.
- Demo transparency: any showcased property/stay imagery is "representative imagery"; demo stays are labelled "Demo stay" quietly in the UI, never promoted as real inventory on renamed brands.

## Feature block (wkhotelfeaturesblock) content rules
- Exactly 4 active cards stored in `htl_features_block_data`, idempotently synced by `seed-rural-up-demo.php` (syncFeatureBlocks).
- Topics: (1) Farmstay rooms, (2) Home-style UP kitchen, (3) Local experiences, (4) Clear, easy booking.
- Card icons come from the theme sprite `rural-up-icons.svg` (bed, food, compass, shield symbols); no Unicode glyphs on cards.
- Section heading/eyebrow stay: "Book with confidence" / "The details that make a good stay easier" / "Simple booking, thoughtful places and support when you need it."

## Media sourcing rules
- Subject matter must be Indian and place-accurate: Awadh → Bara Imambara/Lucknow heritage, Bundelkhand → Orchha/Jhansi, Braj → Mathura/Vrindavan temple, Purvanchal → Ayodhya Ram Mandir/Sarayu, Rohilkhand → Pilibhit Tiger Reserve, Kashi → Varanasi ghats. Property covers: mango groves, orchards, temple courtyards, paddy/Sarayu fields, terai grassland, Banarasi silk looms.
- Preferred source: Wikimedia Commons. Each file MUST have a verifiable free license (CC0 / CC BY / CC BY-SA / PD). No "fair use", no editorial-only, no noncommercial (NC) or no-derivatives (ND) variants, no watermarked/stamped previews.
- Attribution: author, exact license, and source file URL recorded in docs/RURAL-UP-MEDIA.md for every asset; file kept on disk under themes/rural-up-theme/img/editorial/ with descriptive names.
- Size targets: region covers 1600x900; property covers 4:3 aspect at ~1600px wide; not upscaling; quality >= 0.85 JPEG.
- Replacement rule: only swap a candidate if license check passes and subject matches the region/property story; otherwise fall back to the next candidate.

## Seeder refresh contract
- `php /usr/local/bin/seed-rural-up-demo` = idempotent; skips existing media unless `--refresh-images` is passed (hash compare on editorial sources).
- Region covers are written to `img/fhregions/` (images volume); hotel covers live in `modules/hotelreservationsystem/views/img/hotel_img/` and are restored from editorial sources on each reseed.