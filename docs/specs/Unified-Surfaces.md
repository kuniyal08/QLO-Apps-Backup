# Spec: Unified-Surfaces

Scope: feature

# Unified Rural UP Surfaces and Utility Footer

## Status
The current Rural UP homepage still has rejected visual defects: sections feel like mismatched/clipped rectangles and the visible footer remains a mixture of stock module columns. This specification corrects those surfaces before any downstream journey redesign proceeds.

## Approved Homepage Rhythm
- Use a mostly continuous inherited paper background after the hero.
- Featured Stays, Regions, Activities, and Stories must not each read as isolated background panels.
- Benefits and Testimonials are the only restrained tonal breaks, using subtle sage or equivalent approved brand tint.
- Card surfaces remain intentionally distinct, but section root surfaces must flow continuously.
- Do not conceal geometry defects through `overflow-x:hidden`. Correct the inherited Bootstrap scaffold at the homepage scope.

## Required Scaffold Correction
- The active homepage path is `#index .columns-container > #columns.container > .row > #center_column > main.ru-home`.
- Neutralize the inherited negative margins of `#index #columns > .row` and ensure `#center_column`, `.ru-home`, and immediate hook wrappers are width-consistent with their parent.
- At 375px, 768px, and 1440px, `document.documentElement.scrollWidth` must equal `window.innerWidth` without clipping content.
- Keep the correction strictly homepage-scoped. Do not alter global Bootstrap behavior for booking, checkout, or account pages.

## Footer Direction
Build a Booking.com-inspired travel utility footer, not a generic marketing block and not a MakeMyTrip-style dense destination directory.

### Required hierarchy
1. Rural UP brand/support block with concise trust/support copy.
2. Explore links: properties, regions, activities, stories.
3. Plan and manage: account, trips/booking history, contact/support.
4. Help and policies: relevant CMS/legal links and factual payment/cancellation help.
5. Newsletter utility when configured, retaining subscription/GDPR/AJAX contracts.
6. Payment confidence and language/currency hook output.
7. Legal/copyright bottom bar and `displayAfterDefautlFooterHook` output.

### Footer contracts
- Preserve `displayFooterBefore`, `$HOOK_FOOTER`, `displayAfterDefautlFooterHook`, and global footer includes.
- Preserve nested provider hooks: `displayFooterMostLeftBlock`, `displayFooterPaymentInfo`, `displayFooterNotificationHook`, `displayFooterExploreSectionHook`, and newsletter hooks.
- Theme overrides must replace visible module fragments, never modify module/core files.
- Footer lists must be valid HTML: discovery links emitted as `<li>` children of their owning list, never nested standalone `<ul>` inside a `<ul>`.
- Scope all replacement CSS to Rural UP footer classes to prevent legacy global footer styles from leaking into the new layout.
- Mobile footer stacks clearly above the persistent bottom navigation with no overlap and 44px link targets.

## Acceptance
- Continuous paper flow is visible across Featured Stays, Regions, Activities, and Stories.
- Benefits and Testimonials are intentional, subtle tonal moments only.
- No background panels are clipped or offset by the legacy row geometry.
- Footer presents one coherent Booking-style utility system and no visibly stock 2017 column/module treatment remains.
- Existing footer links, discovery links, language/currency/payment/newsletter provider output and hooks remain functional where configured.
- Live visual checks at 375px, 768px, and 1440px show no horizontal overflow, console errors, Smarty/PHP errors, or invalid visible nested lists.
- Pause for user approval after implementation.