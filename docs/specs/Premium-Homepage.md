# Spec: Premium-Homepage

Scope: feature

# Premium Rural UP Homepage Rebuild

## Status and Intent
The current Rural UP homepage implementation is rejected. It is a superficial CSS layer over stock QloApps templates and must not be treated as an acceptable baseline. This specification requires a complete homepage rebuild at theme-template and module-override level before the remaining customer journey continues.

## Approved Direction
- Hero: one immersive full-width rural editorial image, restrained headline and supporting copy, and one integrated Booking-style search component at the lower edge.
- Character: Airbnb-like warmth, image restraint, whitespace and editorial polish combined with Booking.com-like search clarity, price/trust utility, and conversion hierarchy.
- Homepage sequence: hero/search, featured stays, trust/benefits, regions and activities, stories, testimonials, complete footer.
- Stock Interiors carousel: remove from visible homepage output. Do not delete its module or files.
- Amenities: replace the stock amenity grid with guest-relevant benefits/trust presentation.
- Rooms: rebuild as Featured Stays cards.
- Testimonials: rebuild as restrained social proof, not a stock carousel.
- Typography: one self-hosted editorial display serif plus one highly readable modern sans, with later Hindi/Devanagari compatibility documented.
- Approval gate: stop after complete responsive homepage implementation and QA. Obtain explicit user approval before redesigning results, room detail, cart, checkout, account, or utility pages.

## Non-Negotiable Structural Corrections
- Remove the dual-hero render. The stock `hotelreservationsystem` hero and theme `index.tpl` must not render competing hero copy.
- Remove negative-margin hero assembly and viewport-height inline dependencies as structural layout mechanisms.
- Give the homepage hero one template owner and intentional search placement.
- Do not force a modern grid over legacy inline spans. Replace the `wkroomsearchblock` theme markup while preserving functional selectors.
- Do not rely on `my-farmhouse-child-theme` CSS or SVG definitions. The new theme owns every component and asset it renders.
- Do not use broad global `.btn`, `.card`, `.box`, or generic heading overrides as the primary redesign method. Use scoped component markup/classes.
- Replace every visible homepage provider with a `rural-up-theme` override: `hotelreservationsystem`, `wkroomsearchblock`, `fhregions`, `wkhotelroom`, `wkhotelfeaturesblock`, `fhblog`, `wktestimonialblock`, relevant review-badge output, and footer providers.
- Preserve hooks and module extension points even where provider output is currently absent.

## Search Contract
The rebuilt search must preserve:
- Form `#search_hotel_block_form` and wrapper `#search_form_fields_wrapper`.
- Location `#hotel_location`, `#location_category_id`, `.location_search_results_ul`, `.search_result_li`.
- Hotel selectors and hidden values: `#id_hotel_button`, generated Chosen behavior, `#id_hotel`, `#hotel_cat_id`, `#max_order_date`, `#min_booking_offset`.
- Date controls: `#daterange_value` or split date IDs, hidden `#check_in_time`, `#check_out_time`, and `.input-date`.
- Occupancy controls: `#guest_occupancy`, `#search_occupancy_wrapper`, `#occupancy_inner_wrapper`, `.occupancy-room-block`, occupancy inputs/names, counters, add/remove room, child ages, errors, and Done action.
- Submit `#search_room_submit` with `name="search_room_submit"`.
- Mobile IDs and existing Fancybox/datepicker/occupancy runtime contracts unless an implementation safely wraps them without changing behavior.
- Hooks `displaySearchFormFieldsBefore` and `displaySearchFormFieldsAfter`.

The desktop presentation is a coherent segmented bar: destination/property, check-in, check-out, guests/rooms, primary Search action. Mobile uses a clear full-width search summary that opens a spacious sheet while retaining contractual controls and keyboard focus behavior.

## Media Rules
- Use commercially licensed Unsplash, Pexels, or similarly approved imagery.
- Download and self-host all runtime media; no hotlinks.
- Record source URL, creator/source, license basis, intended placement, dimensions, and optimized output.
- Hero, region, activity, and story imagery may be editorial placeholders and must not imply ownership of the depicted place.
- A named property/stay must use authentic seeded property media where acceptable or a designed branded placeholder. Generic stock media must never silently represent a named property.
- Avoid recognizable people unless model-release suitability is verified.
- Generate responsive formats/sizes where practical, preserve aspect ratios, set dimensions, lazy-load below-fold imagery, and do not lazy-load the hero LCP image.

## Homepage Components
### Header
- Compact, high-quality navigation with Rural UP provisional wordmark/symbol treatment, primary discovery links, support, account and booking-cart/trips state.
- Responsive drawer on mobile with accessible open/close/focus behavior.
- Preserve `displayNav`, `displayTop`, `displayHeader`, and relevant extension hooks.

### Hero and Search
- One visual composition, no duplicate hotel-chain headline.
- Strong editorial image, dark-enough contrast treatment, concise copy, factual trust cues.
- Search appears integrated rather than floating as an unrelated dialog.
- Avoid excessive rounded rectangles, dashboard-field appearance, generic gradients, or oversized shadows.

### Featured Stays
- First section after hero to reinforce conversion.
- Photo-forward cards where authentic media exists; designed placeholder otherwise.
- Show name, location/context, nightly from-price where supplied, verified review output where real, concise benefit, and clear view/book path.
- Do not fabricate ratings, availability, prices, or cancellation claims.

### Trust and Benefits
- Replace the stock Amenities block with guest-relevant reasons to book: verified stays, clear prices, local support, secure booking, and factual cancellation/policy cues where data supports them.
- Use one icon family and concise content.

### Regions and Activities
- Region cards use licensed editorial covers and meaningful metadata.
- Empty counts do not leave unfinished blank regions.
- Activities remain informational and never enter cart or payment.
- All-region/activity links have valid icons and touch targets.

### Stories and Testimonials
- Stories use editorial card layouts and licensed images.
- Testimonials use real configured content and restrained proof formatting.
- No default Owl carousel presentation is required; prefer a stable responsive grid/scroll strip without adding a library.

### Footer
- One coherent footer with valid HTML and consistent hierarchy.
- Preserve footer hook calls and provider extensibility.
- Include brand/support, stays, regions/activities/stories, help/policies, language/currency where configured, payment reassurance, and contact channels.
- Fix nested list invalidity and missing icon references.

## Accessibility and Responsive Acceptance
- Validate at 375px, 768px, and 1440px.
- No horizontal overflow.
- Touch targets at least 44px.
- WCAG 2.2 AA contrast, visible keyboard focus, semantic headings, labels and navigation.
- Mobile search, drawer and occupancy interactions remain keyboard usable and return focus appropriately.
- Respect `prefers-reduced-motion`.
- Long English and future Hindi content must wrap without clipping.

## Functional and Quality Acceptance
- Every visible homepage section uses `rural-up-theme` markup and its own loaded style system; no visibly stock QloApps section remains.
- Hero/search is one coherent composition.
- Search autocomplete, hotel selection, date range, occupancy add/remove/ages, and submit continue working.
- Homepage links to properties, regions, activities, stories, account, support, and cart/trips resolve correctly.
- No missing SVG symbols, unstyled `fh-*` output, invalid nested lists, console errors, Smarty/PHP errors, or broken image requests.
- Hero LCP asset is prioritized and optimized; below-fold media is lazy-loaded.
- Live responsive homepage is presented to the user and implementation pauses for approval before downstream templates are changed.