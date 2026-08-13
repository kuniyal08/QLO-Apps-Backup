# Spec: Demo-Farmstays

Scope: feature

# Demo Farmstay MVP Content

## Purpose
Create six presentation-ready, genuinely bookable QloApps demonstration farmstays across Uttar Pradesh without modifying reservation, availability, cart, checkout, confirmation, or payment-provider logic.

## Properties
- Gomti Mango House, Lucknow outskirts, Awadh
- Orchard Ridge Farmstay, Bundelkhand
- Yamuna Courtyard Farmstay, Braj
- Sarayu Fields Retreat, Purvanchal
- Terai Wetlands Farmstay, Rohilkhand
- Ganga Looms Country House, Kashi

## Content Rules
- Each record is visibly labelled: `Demo stay · representative imagery`.
- Imagery is local and self-hosted; it must not be hotlinked at render time.
- Every asset has source URL, provider/license, creator when available, intended crop, local filename, and replacement status documented.
- Demo images must be described as representative rather than authentic photographs of the named property.

## Booking Boundary
- Each property must be an active hotel with a hotel cover/gallery, one active front-visible booking room type, room cover, price, and at least two active physical rooms.
- Properties must be created only through supported QloApps hotel/room/import/admin workflows, never direct SQL fixtures or runtime database mutations.
- Each property is linked to exactly one existing region using FhRegion supported links.
- Preserve all QloApps search form contracts, availability behavior, product/category URLs, cart/AJAX targets, checkout/payment submissions, and booking confirmation routes.

## Presentation
- Homepage property cards are property-led: property cover, location/region, concise farmstay copy, demo disclosure, and link to the property/category destination.
- Specific room types remain discoverable/bookable through the property destination and existing availability flow.
- Regions have complete local cover media and Rural UP cards/detail heroes; fallback states are intentional and accessible.
- Non-home routes use a compact header, never the homepage 650px hero.

## Acceptance
- All six properties are visible in the property directory, their regions, and the homepage showcase.
- All supplied media and SVG assets return successfully from local URLs.
- Property room types are returned by date/occupancy search and can traverse product, cart, and checkout interfaces.
- Region list/detail, discovery, customer utility, and payment-error surfaces have no missing icons, raw legacy fallback layouts, broken media, or empty homepage-header spacing.
- Route QA is performed at 375px, 768px, and 1440px; presentation changes produce no Smarty/PHP/frontend errors.