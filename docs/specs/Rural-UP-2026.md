# Spec: Rural-UP-2026

Scope: feature

# Rural UP 2026 Frontend Redesign

## Objective
Deliver a coherent, production-ready 2026 frontend for the QloApps rural Uttar Pradesh stay platform. Phase 1 is a four-week visual release over existing behavior. It creates a new independent `themes/rural-up-theme` from the untouched `themes/hotel-reservation-theme`; it must not overwrite or delete `themes/my-farmhouse-child-theme` or the default theme.

## Confirmed Product Direction
- Working identity: Rural UP, pending later stakeholder naming approval.
- Audience: domestic leisure travelers, Uttar Pradesh residents, international travelers, and government travelers.
- Positioning: rural farmhouses and live-in stays in Uttar Pradesh. Do not claim official government endorsement, use official seals/emblems, or expose ownership/development claims until wording and data are approved.
- Art direction: editorial rural modern, combining Airbnb-like warmth and restraint with Booking.com-like utility and information clarity.
- Identity deliverable: two coded concepts at the first milestone; approve one wordmark-plus-symbol direction before broad implementation.
- Imagery: landscape, architecture, courtyards, fields, food, craft, and non-identifiable lived details. Download, optimize, self-host, and document commercially licensed placeholder media. Never present generic stock media as a specific property; use designed placeholders when authentic property photography is absent.
- Language: English first; all strings translation-ready and layouts safe for later Hindi content.
- Device model: one responsive theme for mobile, tablet, and desktop. Explicitly disable the legacy mobile-theme path. Mobile shell uses a compact header plus primary bottom navigation.
- Accessibility: WCAG 2.2 AA, keyboard access, visible focus, semantic forms, reduced-motion support, sufficient contrast, and at least 44px targets.
- Browser support: latest two versions of Chrome, Edge, Firefox, Safari, iOS Safari, and Android Chrome; no Internet Explorer support.
- Performance: production-like targets of LCP <=2.5s, INP <=200ms, and CLS <=0.1.

## Phase 1 Scope: Four-Week Visual Release
Phase 1 redesigns existing functionality only and retains the current hotel-first search behavior. Booking-journey quality takes priority, but all relevant customer surfaces receive a consistent baseline.

### Required Surfaces
- Shared shell: header, navigation, responsive bottom navigation, footer, search hook area, cart/account states, breadcrumbs, pagination, drawers/modals, forms, alerts, loading, empty, and error states.
- Homepage: destination/dates/guests search presentation, trust content, featured stays, regions, informational activities, stories, support, and consent-ready UI.
- Existing discovery: properties directory, category/availability results, generic search where retained, current sorting, current price/amenity filters, region list/detail, activities, and blog list/detail.
- Property/room: gallery, authentic-media fallback, amenities, policies, verified-stay review output, nightly from-price, selected-stay total where dates exist, factual availability, per-rate cancellation terms, occupancy, quantity, services, booking CTA, and unavailable states.
- Booking: cart, one-property-per-booking behavior, existing account-required one-page checkout, current guest/address inputs, terms, payment hooks, bankwire/cheque UI and execution/return states, validation failures, confirmation, and post-booking support.
- Account: authentication/registration, password recovery, dashboard, identity, addresses, booking history/detail, refunds/returns/slips/vouchers where enabled, and guest-tracking surfaces that remain reachable.
- Content/system: contact/help, CMS/legal, content-only terms, newsletter responses, sitemap, 404, maintenance, restricted-country, empty/no-results, and generic errors.
- Support: phone, email, and a WhatsApp support deep link. WhatsApp does not perform booking logic.
- Consent: provider-neutral consent UI and integration points; optional analytics must not load before valid consent.

### Checkout and Payments
- Phase 1 supports and tests only the currently configured account-required OPC branch.
- Preserve and visually normalize all payment hook output.
- Do not implement or modify booking/payment logic in this frontend phase.
- Indian gateway/Razorpay-compatible work and pay-at-property are separate reviewed module workstreams.

### Legacy Routes
Retail-era PrestaShop routes such as best sellers, new products, price drops, manufacturers, suppliers, product comparison, and store locator should be retired through separately reviewed, non-destructive redirects to relevant stay-discovery pages. Do not redesign them as launch destinations. Do not delete files without explicit approval.

## Design System Requirements
- One coherent typography family pairing, one coherent licensed/self-hosted icon family, and a restrained rural-UP palette approved through coded concepts.
- Reusable tokens for type, spacing, color, radii, elevation, layering, animation, breakpoints, focus, success/warning/error, and skeleton/loading behavior.
- Reusable components for search segments, buttons, cards, media, chips, review badges, policy badges, price blocks, property/room summaries, filters, form controls, steppers, progress, payment options, account tiles, support cards, consent, and system states.
- New user-facing strings must use the proper QloApps/Smarty translation method.
- Use modern 2026 interaction quality without adding AI, a map, novelty effects, excessive animation, or new frontend frameworks.

## QloApps Contract Invariants
- Preserve all existing core and module hooks, including shared shell, home, search, category/list, room detail, cart, checkout, payment, confirmation, account, and footer extension points.
- Preserve Smarty variables, form methods/actions, input names/IDs, hidden fields, selectors, Bootstrap behavior classes/data attributes, AJAX fragment paths, and JavaScript contracts.
- Preserve the `wkroomsearchblock` destination/date/occupancy behavior and its exact runtime selectors.
- Preserve `booking-form`, occupancy, quantity, availability, service, cart, `order-opc.js`, payment, and confirmation contracts.
- Preserve `HOOK_PAYMENT`, advanced/return hook slots that render inside the configured flow, cart hooks, order-confirmation hooks, review hooks, and account hooks even where providers are currently absent.
- Do not alter booking calculations, availability, pricing, tax, cancellation, payment, refund, or authentication logic as part of Phase 1.
- Keep activities informational and non-bookable.
- Module UI should be overridden through the new theme where possible. Core changes require separate justification; payment/booking changes require explicit approval.

## Media and Content Rules
- Use licensed Unsplash/Pexels or similarly approved assets downloaded and self-hosted; no runtime hotlinking.
- Record source URL, creator/source, license basis, intended placement, and optimization output.
- Avoid recognizable people unless the license/model release is verified.
- Add explicit dimensions/aspect ratios, responsive formats, and lazy loading below the fold; do not lazy-load the LCP image.
- Provide provisional, friendly, factual, translation-ready copy and a replacement/content-entry guide.
- Do not fabricate ratings, scarcity, cancellation benefits, government status, property details, or review counts.

## Acceptance and Approval
- Milestone approvals: identity/design system; shell/home; discovery/property/booking; account/content; final QA/activation.
- Identity concepts are coded responsive pages in the actual theme context, not detached mockups.
- Source of truth for development QA is the local seeded Podman stack; perform a staging smoke test if access is supplied.
- Validate at representative phone, tablet, and desktop widths, including logged-out/logged-in, empty/populated, validation/error, and long-text states.
- Complete regression: home -> destination search -> selected hotel availability -> room -> occupancy/services -> cart -> account/authentication -> OPC -> enabled payment state -> confirmation.
- Confirm no horizontal overflow, no unintended console/PHP errors, preserved hook output, keyboard usability, screen-reader labels/semantics, responsive touch behavior, and Core Web Vitals targets.
- Current seed data is limited; explicitly document the scale-testing gap instead of claiming validation against 150+ real properties.

## Phase 2 Boundaries
Phase 2 is separately designed and approved. It may add:
- Property-first destination results, followed by room choice.
- Availability-and-relevance default ranking.
- Region, distance, amenities, stay type, activity, price, rating, and policy filters.
- Account-synced favorites.
- Scalable demo fixtures and performance validation for more than 150 properties.
- Existing admin concepts should be reused: hotel features, regions, activities, configuration, and review data. Ownership/development type remains internal.
- New schema is limited to module-owned tables where unavoidable, particularly favorites and search metadata/indexes; schema proposals require review before implementation.
- No map at launch, no AI at launch, and no multi-property cart.
- Indian online gateway and pay-at-property integrations are separate payment-module specs and require explicit authorization, security review, sandbox verification, and booking/payment regression.