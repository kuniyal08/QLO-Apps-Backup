---
plan name: Homepage-Rebuild
plan description: Premium visual direction reset
plan status: active
---

## Idea
Correct the rejected Rural UP prototype by fully rebuilding the active `themes/rural-up-theme` homepage at template and module-override level rather than layering CSS over stock QloApps markup. Deliver one cohesive responsive homepage with a single immersive licensed-photo hero, an integrated Booking-style search component, Airbnb-like editorial warmth, stay-conversion-first content hierarchy, self-hosted editorial-serif and modern-sans typography, one icon system, intentional designed placeholders for named stays lacking authentic media, and complete replacement of the visible default module stack. Preserve every QloApps hook, search form field, selector, occupancy/date behavior, translation contract, and AJAX path. Stop after desktop/mobile homepage QA for user visual approval before results, room detail, cart, checkout, account, and utility surfaces continue.

## Implementation
- Capture the current rendered homepage at phone, tablet, and desktop widths and record its exact hook/provider order, visual defects, CSS conflicts, missing assets, and search contracts as the rejected baseline; do not reuse the dual-hero or negative-margin structure.
- Define the approved homepage art direction in theme-owned design tokens: self-hosted editorial serif plus modern sans, rural-UP palette, spacing, containers, radii, elevation, iconography, media ratios, focus states, reduced motion, and responsive behavior; replace broad global `.btn`/`.card` overrides with scoped component classes.
- Curate commercially licensed rural editorial imagery for hero, regions, activities, and stories from approved sources; download, resize, optimize, and self-host responsive files; record source URLs and license basis; create polished branded placeholders for named stays without authentic property media.
- Replace the header and hero pipeline so one template owns the homepage hero: remove viewport-height inline dependencies and negative-margin composition, override the `hotelreservationsystem` hero provider, preserve all header/navigation hooks, and integrate copy, image, trust cues, and search into one intentional composition.
- Create complete theme overrides for `wkroomsearchblock` landing, form, and mobile templates; encode the segmented destination/property, dates, guests, and search layout in markup instead of conflicting CSS; retain every contractual ID, field name, hidden value, Chosen/date/occupancy selector, hook, and submit behavior; implement a responsive mobile search sheet using existing behavior safely.
- Replace the homepage `fhregions` output with a complete conversion-oriented regions section using licensed editorial covers, useful metadata, intentional empty states, valid icons, and a polished All Regions action; include the activity discovery strip in the same coherent system without relying on missing `fh-*` CSS from another theme.
- Replace homepage providers for `wkhotelroom`, `wkhotelfeaturesblock`, `fhblog`, and `wktestimonialblock`: featured stays first using authentic seeded media or designed placeholders, benefits/trust instead of stock Amenities, activities and regions as discovery, stories as editorial cards, testimonials as restrained proof, and remove the stock Interiors carousel from visible homepage output while preserving its module outside this surface.
- Rebuild the homepage footer provider overrides into one valid, coherent footer with brand/support, Stays, Explore, Policies, language/currency, payment reassurance, and contact information; preserve footer hooks while eliminating invalid nested lists, missing icons, and independent stock module columns.
- Implement scoped homepage CSS and minimal accessible JavaScript for the owned markup, with desktop/tablet/mobile compositions, 44px targets, keyboard focus, reduced motion, no horizontal overflow, image aspect ratios, below-fold lazy loading, and no carousel dependency.
- Clear Smarty caches only during implementation validation, then run live QA at 375, 768, and 1440 widths: search autocomplete/dates/occupancy/submit, navigation, links, missing-media states, console/PHP errors, WCAG 2.2 AA checks, and Core Web Vitals-oriented asset checks; compare against the rejected baseline.
- Present the rebuilt live homepage for user approval and pause. Do not continue to results, property/room detail, cart, checkout, account, or content redesign until the visual direction is explicitly approved; after approval, apply the same component system through the remaining `Rural-UP-Redesign` plan using template-level replacements.

## Required Specs
<!-- SPECS_START -->
- Premium-Homepage
<!-- SPECS_END -->