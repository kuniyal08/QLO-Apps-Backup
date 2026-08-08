---
plan name: Rural-Marketplace
plan description: Customer journey transformation
plan status: active
---

## Idea
Refine the existing responsive Material 3 marketplace theme into a complete branded rural Uttar Pradesh stay-discovery experience for roughly 100-150 properties, without changing the QloApps hotel, availability, cart, booking, payment, or admin backend contracts. Establish a distinct rural-culture brand direction, improve property and activity discovery, finish responsive account/policy/review surfaces, support English and Hindi-ready content, and verify the entire stay-only journey on desktop and mobile.

## Implementation
- Audit the active child theme, module-template overrides, current QA captures, and live frontend behavior; document preserved IDs, hooks, variables, and JavaScript contracts for every booking-flow page.
- Define the customer-facing brand system for rural Uttar Pradesh stays: brand name direction, typography, color tokens, illustration/photography direction, icon usage, content voice, and accessible desktop/mobile interaction standards.
- Refine the shared child-theme shell in header, footer, navigation, utility surfaces, and global CSS so the new visual direction is responsive, accessible, translation-safe, and compatible with existing QloApps/module hooks.
- Improve the stay-discovery journey: homepage hero/search, editorial property categories, property directory filters/cards, location-led discovery, and responsive empty/loading states while retaining the existing availability-search form contract.
- Create informational activities and event discovery surfaces: homepage sections, browse/filter presentation, and property-detail activity panels using hooks or a dedicated module, explicitly excluding activities from inventory, cart, checkout, and payment.
- Refine property and room-detail templates for gallery, amenities, rooms, availability, guest occupancy, local experiences, policies, ratings/reviews, SEO metadata, and clear mobile conversion paths without modifying booking calculations.
- Complete the authenticated customer journey: cart, checkout, payment option presentation, confirmation, account/history, cancellation guidance, contact/help, privacy/policy pages, and Hindi-ready responsive layouts; defer payment-provider and OTP logic to their dedicated modules.
- Run functional and visual regression checks across desktop and phone breakpoints for search, availability, room booking, cart, checkout, account, and content pages; confirm preserved hooks/selectors, no horizontal overflow, translation wrapping, keyboard access, and cache-refresh requirements.
- Update the project guide and client requirements with completed frontend decisions, component conventions, content-entry guidance for properties/activities, visual QA evidence, and known boundaries for subsequent Razorpay, SMS, OTP, reviews, and caretaker modules.

## Required Specs
<!-- SPECS_START -->
- Rural-Frontend
<!-- SPECS_END -->