# Spec: airbnb-premium-treatment

Scope: feature

# Airbnb-Inspired Premium Treatment (client-confirmed)

Scope: feature. Companion to plan `complete-frontend-redesign` and spec `redesign-remaining-surfaces`. Supersedes the "restyle with tokens" assumption: all remaining stock 2017 templates are REPLACED in place (same filenames) with premium, Airbnb-inspired markup.

## Confirmed decisions (client, 2026-08)

| # | Question | Decision |
|---|----------|----------|
| A1 | Premium definition | Airbnb-inspired: photo-forward, soft cards, pill CTAs, generous whitespace, friendlier copy voice |
| A2 | Tokens | KEEP farmhouse brand tokens (cream paper #F7F4EF, forest green #2F4A3C, terracotta #C46A3B, Fraunces display + Manrope body) — Airbnb TREATMENT applied on top, not a re-token |
| A3 | Template strategy | Replace file CONTENTS in place, keep every filename (Smarty/controller dispatch contract). No files deleted. |
| A4 | Sweep breadth | All REACHABLE surfaces. Dead-route legacy templates (manufacturer, best-sales, discount, comparison, order-address* PS-1.6 era, order-slip/return/follow, new-products, scenes) are NOT rewritten in this pass; document them as known-deferred |
| A5 | Checkout | Keep QloApps one-page flow + order-opc.js contract; rebuild every step section with premium components |
| A6 | Home content | Keep current styled content (interior/amenities/rooms/testimonials + discovery sections) — no re-curation this pass |
| A7 | Imagery | Photo cards where real images exist (rooms, region/blog covers); property (hotel) cards keep monogram cover DESIGNED PREMIUM (rich tinted gradient, fine detail); no new media sourcing |

## Treatment principles (apply to every replaced surface)

- Soft-white paper feel: keep cream, but cards read as elevated soft-white panels (large 24-32px radii on media, 16-20px on cards, hairline borders ~1px rgba(31,27,22,.08), soft shadows 0 1px 2px + 0 12px 32px rgba(31,27,22,.08)).
- Photo-forward: media takes at least 50-55% of card height; image edge touches card edge (no inset padding on media); hover = subtle scale (transform, contain).
- Type treatment: Fraunces for display/headings stays; body Manrope/system; copy rewritten friendlier and benefits-led ("Free cancellation until…", "Stays near you", not "Submit Your Query"). All strings through {l s='...'}.
- CTAs: pill radius, forest-primary solid; ghost/secondary white w/ border; min-height 44-48px on touch surfaces.
- Forms: floating/hollow label look (label above field), 48px inputs, hairline borders, focus ring forest 2px.
- Whitespace: section py 64-96px, gutter 24/40/container 1200-1280px.
- Elevation hierarchy: cards raised, sticky bars elevated-2, modals/drawers elevated-3.
- Motion: transform/opacity only, 150-250ms, prefers-reduced-motion respected; no carousels.
- Touch: >=44px targets everywhere; visible keyboard focus.

## Surface-by-surface expectations

- Footer band: branded — blurb w/ serif lockup + tagline, Explore (Regions/Activities/Stories/Our Properties), Policies links, Contact email/phone + payment marks; columns collapse to stacked cards (no accordion JS needed) on phone; empty blocks (social icons, subscribe) dropped. Hook call sites in footer.tpl stay untouched.
- Breadcrumb/pagination: pill back-link + quiet chevron breadcrumb; pagination = numbered pills with active forest, 44px.
- Auth + account: split-screen login (photo/benefits panel on desktop, hidden on phone); my-account = card grid w/ icon tiles; forms = the field treatment above; order-detail/history = timeline-ish summary cards.
- Cart/checkout: room rows as premium summary cards (image thumb 96-120px, per-day price lines), sticky right summary card desktop; 4-step progress pills; payment step = refined radio-cards for bankwire/cheque with emqCheckoutBlock + wkcheckoutpaymentblock output rendered in the existing hook slots; confirmation = success panel w/ reference, guest summary, WhatsApp block.
- CMS/contact/404/maintenance: prose typography, rich contact card, friendly 404 with discovery links.

## Acceptance criteria

- Zero visually-stock-2017 surfaces on reachable pages; every page above carries the Airbnb-treated premium look within farmhouse tokens.
- Guest journey regression passes unchanged: search -> availability -> room -> occupancy -> cart -> checkout -> confirmation at 375/768/1440; zero horizontal overflow, zero console/PHP errors.
- Hook inventory from `redesign-remaining-surfaces` still renders (displayFooter*, displayCart*, HOOK_PAYMENT, emqCheckoutBlock, displayOrderConfirmation, account hooks).
- Caches cleared per change; module overrides cp-synced then baked; atomic commits per surface.