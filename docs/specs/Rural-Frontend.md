# Spec: Rural-Frontend

Scope: feature

# Rural Marketplace Frontend

## Objective
Refine `themes/my-farmhouse-child-theme` into a distinctive, mobile-first rural Uttar Pradesh stays marketplace for approximately 100-150 properties while retaining the existing QloApps hotel-management, availability, stay booking, cart, checkout, payment, and admin workflows.

## Product boundaries
- Stays are the only bookable product.
- Activities, cultural experiences, events, and local stories are informational discovery content only. They must never add inventory, availability, cart lines, checkout steps, or payment requirements.
- Keep the active child theme as the implementation surface. It is a full theme copy, not an inheriting child theme.
- Preserve QloApps and module hooks, Smarty variables, form field names, selectors, and JavaScript contracts, especially for `wkroomsearchblock` and hotel cart/checkout templates.
- Do not alter booking calculations, availability, payment processing, or admin data handling for frontend work.

## Brand and visual direction
- Establish an original, premium-but-grounded rural Uttar Pradesh identity, avoiding generic luxury-resort styling.
- Use editorial rural imagery and a tactile visual system inspired by craft, landscape, courtyards, water, harvest, and local hospitality.
- Define reusable tokens for color, typography, spacing, elevation, controls, cards, badges, and responsive breakpoints.
- Ensure sufficient contrast, keyboard-visible states, 44px or greater touch targets, reduced-motion compatibility, and readable Hindi/English layouts.

## First-release customer journey
1. Homepage: branded narrative, search, trust signals, curated property types/regions, informational experiences/events, local stories, and clear discovery CTAs.
2. Property discovery: responsive properties directory, useful category/location filters based on existing data, property cards, empty states, and direct paths into existing availability search.
3. Room booking: retain destination, dates, occupancy, availability, room details, add-to-cart, and checkout behavior while presenting it consistently on desktop and mobile.
4. Property/room details: gallery, amenities, location, room choices, policies, review presentation where supported, and informational activity/event panels.
5. Complete guest frontend: cart, checkout, order confirmation, authentication/account/history, help/contact, cancellation/refund guidance, and legal/policy templates.
6. Localization readiness: all new user-facing strings use Smarty translations, content accommodates English and Hindi, and no visible hardcoded English is introduced.

## Non-goals and later integrations
- Razorpay, mobile OTP, SMS provider integration, caretaker portals, booking notifications, reviews moderation, and payment/refund backend integration are separate module/backend workstreams.
- This frontend may provide compatible presentation placeholders only when they do not claim unavailable functionality.

## Acceptance criteria
- Existing QloApps booking flow works unchanged: search -> availability -> room -> occupancy -> cart -> checkout -> confirmation.
- All preserved module hooks and documented search-form selectors continue to work.
- Key pages have visual checks at phone, tablet, and desktop widths with no horizontal overflow.
- Navigation, search form, filters, accordions, modal/drawer behavior, form controls, and CTAs are keyboard-accessible and usable by touch.
- Activities/events remain informational and cannot enter cart or checkout.
- Existing checkout/payment hook output continues to render correctly.
- Theme cache-clearing and regression validation are completed after template/style changes.