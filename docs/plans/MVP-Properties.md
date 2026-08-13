---
plan name: MVP-Properties
plan description: Launch-ready farmstay showcase release
plan status: done
---

## Idea
Prepare the Rural UP client MVP for presentation without changing QloApps reservation logic. Create six clearly labelled, real bookable demonstration farmstays across Awadh, Bundelkhand, Braj, Purvanchal, Rohilkhand, and Kashi using supported QloApps hotel, room-type, inventory, image, homepage-curation, and region-linking workflows. Source and self-host representative royalty-free scenic media with complete provenance records. Change the homepage from a room-type-led presentation into a farmhouse/property-led showcase while retaining a clear route to book specific room types. Repair the region listing/detail routes through Rural UP theme overrides, correct the globally inherited empty hero on all non-home routes, then audit and normalize remaining public discovery, utility, and payment/error route shells using presentation-only overrides. Preserve all form contracts, controller variables, selectors, booking search behavior, availability, cart updates, checkout, payment provider submissions, and confirmation flows; no core booking, cart, availability, or provider logic changes are permitted.

## Implementation
- Create a media manifest for six locally stored, licensed, representative scenic property and region images; record source URL, license, creator/source, local filename, crop purpose, and client-replacement status, then optimize self-hosted assets without runtime hotlinks.
- Provision six active demo farmstay records through supported QloApps hotel/room/inventory interfaces: Gomti Mango House (Awadh), Orchard Ridge Farmstay (Bundelkhand), Yamuna Courtyard Farmstay (Braj), Sarayu Fields Retreat (Purvanchal), Terai Wetlands Farmstay (Rohilkhand), and Ganga Looms Country House (Kashi). Give each property a valid address, property cover/gallery, active front-visible booking room type, room cover, price, and two active physical rooms; mark all customer-facing records as demo properties with representative imagery.
- Link each property to exactly one existing Fhregions region using the supported region administration/link model, upload curated region covers, and verify region counts and detail listings reflect linked active properties.
- Replace the homepage room-type-led featured section with a property-led farmhouse showcase that uses hotel cover imagery, regional location, demo disclosure, and property/category destinations; retain a separate path to individual room booking and preserve the existing homepage room-module behavior where it remains necessary for bookable inventory promotion.
- Add Rural UP theme overrides for Fhregions listing and detail templates and scoped Rural UP CSS: render region cover heroes, card media/fallbacks, property imagery where currently available, responsive layout, accessible SVG controls, and existing links/conditions without modifying discovery controller or model behavior.
- Correct the global header rule so only the homepage receives the immersive hero/search overlap; give every other public route a compact Rural UP header and verify no route retains a blank 650px header gap.
- Audit and fix remaining public presentation-only route families in priority order: blog, activities, customer utility/account/contact pages, mobile search trigger, footer hook visibility, and payment provider error/execution shells. Use theme overrides and CSS only; retain all module forms, hidden fields, payment branding, IDs, names, hooks, and submission contracts.
- Run route-family QA at 375px, 768px, and 1440px: homepage, properties, each region/list/detail, search/results, room/product, cart, checkout, authentication/account, contact, blog, activities, and payment error/execution surfaces. Verify images and SVGs load, no horizontal overflow or empty hero gaps, keyboard focus/touch targets, search refresh, cart/AJAX updates, booking availability, checkout route rendering, and absence of frontend/Smarty/PHP errors.
- Document the final demo property inventory, image provenance, public demo disclosure rule, region associations, route audit outcomes, booking-preservation boundary, and the client handover procedure for replacing demo content with real property information.

## Required Specs
<!-- SPECS_START -->
- Demo-Farmstays
<!-- SPECS_END -->