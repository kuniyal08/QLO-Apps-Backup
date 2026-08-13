# Rural UP Demo Properties

## Purpose

This client-MVP inventory demonstrates the Rural UP presentation while preserving the standard QloApps booking engine. Each property and image is demo content and must be replaced with client-approved information before production.

## Seed Command

The idempotent command is installed in the development web image:

```sh
podman exec qloapps_web_1 php /usr/local/bin/seed-rural-up-demo
```

Pass `--refresh-images` to re-derive all demo media (region covers, hotel covers, room-product covers) from the editorial sources in `themes/rural-up-theme/img/editorial/` — use it after replacing any of the demo image files:

```sh
podman exec qloapps_web_1 php /usr/local/bin/seed-rural-up-demo --refresh-images
```

It uses QloApps models to create or reuse hotels, categories, room products, active physical rooms, hotel/product images, homepage selections, region links, and region covers. It does not write booking, cart, checkout, payment, or availability records directly.

## Feature Block

The seeder keeps the four "Book with confidence" homepage cards aligned with the farmstay product on every run:

1. **Farmstay rooms** — Veranda suites and orchard rooms with open skies, warm quilts and village mornings.
2. **Home-style UP kitchen** — Farm-fresh thalis and evening chai, cooked with produce from local fields and orchards.
3. **Local experiences** — Heritage walks, village looms and riverfront evenings, arranged by your hosts.
4. **Clear, easy booking** — Transparent prices, instant confirmation and local support during your stay.

Card icons come from the theme sprite (`rural-up-icons.svg`: bed, food, compass, shield). Replace card copy with live content through the `wkhotelfeaturesblock` editor in Back Office; the seeder restores the demo copy on the next run.

## Demonstration Inventory

| Farmstay | Region | City | Room type | Demo nightly price | Inventory |
| --- | --- | --- | --- | --- | --- |
| Gomti Mango House | Awadh | Malihabad | Orchard Verandah Suite | INR 7,200 | 2 active rooms |
| Orchard Ridge Farmstay | Bundelkhand | Jhansi | Granite Ridge Cottage | INR 6,100 | 2 active rooms |
| Yamuna Courtyard Farmstay | Braj | Mathura | Courtyard Garden Room | INR 6,800 | 2 active rooms |
| Sarayu Fields Retreat | Purvanchal | Ayodhya | Sarayu Field Cabin | INR 5,900 | 2 active rooms |
| Terai Wetlands Farmstay | Rohilkhand | Pilibhit | Wetland Watch Suite | INR 7,600 | 2 active rooms |
| Ganga Looms Country House | Kashi | Varanasi | Weaver's Courtyard Room | INR 7,400 | 2 active rooms |

## Content Rules

- Every property is shown as `Demo stay · representative imagery`.
- Media is self-hosted and documented in `docs/RURAL-UP-MEDIA.md`.
- Region assignment is the Rural UP discovery classification.
- The local database does not include a state record for Uttar Pradesh. Demo hotel addresses use the supported India-plus-city address path; the linked region remains the public classification. Add the official state in Back Office before production if state-level address filtering is required.

## Client Handover

1. Replace demo name, address, contact, pricing, descriptions, policies, and room inventory in QloApps Back Office.
2. Upload actual property gallery and room images through the hotel and room-type editors.
3. Keep one active hotel cover and one product cover per property.
4. Keep at least one active physical room per sellable room type; retain two or more where concurrent bookings are desired.
5. Update each region's property links in the UP Regions editor.
6. Replace the homepage selections in Manage Hotel Rooms Display when the live inventory is ready.
7. Remove the demo disclosure only after genuine property information and approved imagery replace the corresponding record.
