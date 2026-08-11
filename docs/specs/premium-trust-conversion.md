# Spec: premium-trust-conversion

Scope: feature

# Spec: Premium Trust, Pricing & Performance Pass

Scope: feature. Companion to plan `premium-home-pass` (second spec; extends `premium-search-hero`). Goal: close the trust, pricing-transparency and perceived-performance gaps that make OTA frontends (Booking.com/Airbnb) feel premium — using ONLY existing data and frontend changes. No backend queries beyond existing module helpers, no new booking/payment logic.

## 1. Trust & Reviews Cluster

**Evidence:** Booking.com's PDP/SRP are built on trust at scale — verified reviews, review-score badges on every card, real (not manufactured) scarcity. CMA lesson: urgency must be factual; Booking's modern tone is neutral/green, restrained. QloApps reality: `qlohotelreview` module ACTIVE (id_module=15) with cached helpers `QhrHotelReview::getAverageRatingByIdHotel($id_hotel)` + `getReviewCountByIdHotel($id_hotel)` (classes/QhrHotelReview.php:122,137); rating hook `displayRoomTypeDetailRoomTypeNameAfter` renders on the product page already; reviews tab renders via HOOK_PRODUCT_TAB.

Work items:
1. **Review badge on listing cards** (category + our-properties room cards + homepage room grid `hotelRoomDisplayBlock.tpl`): "★ 4.8 · 24 reviews" style chip (top-right of card image or under title). Implementation via hook-based integration, NOT template hacks: register the rating into the card rendering path using an existing hook (e.g. `displayRoomTypeListAfter`/`displayRoomTypeListImageAfter` per-card context) — if no suitable per-card hook exposes `id_hotel`, add a minimal custom theme-support module (e.g. `farmhousereviewbadge`) consuming `QhrHotelReview` helpers with its cache; do NOT modify qlohotelreview vendor logic. Hide the chip when a hotel has 0 reviews.
2. **Product page review polish:** restyle the rating row next to the room name (score + count, Book-style chip) and the reviews tab content (verified-guest line "Rated by verified guests", review list typography/ratings) — CSS-only via product.css + account of module classes.
3. **Real-data scarcity in the booking widget** (product page, has date context): show a factual availability line from existing vars (`total_available_rooms`, `max_avail_type_qty`): "Only N rooms left for your dates" only when N <= 2 (or a threshold), neutral tone (no red alarms, no fabricated counters, no "looking now" claims). Purely CSS/template placement of data that already exists.
4. **Footer/trust reinforcement:** keep existing trust strip; no new claims.

## 2. Pricing & Booking-Page Cluster

1. **Per-night + total framing:** verify booking widget and cards show "₹X per night" AND a total for selected dates (widget already computes totals); add "per night" unit label on card price where missing; tax-incl/excl label retained from existing vars (no new price math).
2. **Free-cancellation badge:** QloApps has `HotelOrderRefundRules` (hotelreservationsystem classes) — display a factual "Free cancellation" / "Cancellation policy applies" pill next to the Book CTA ONLY where refund-rule data supports the claim; otherwise omit (never claim without data).
3. **Gallery photo-count badge + lightbox:** on product gallery (`#image-block` + thumbnails): count badge "1/8" or "View all photos" + a lightweight vanilla-JS lightbox reusing the existing gallery image set (hotel_images.tpl/thumbnail.tpl partials); no new libraries, keyboard-close + Escape, `prefers-reduced-motion` respected. (Ties into the icon-system step for the close/chevron icons.)
4. **Cancellation policy clarity:** link/expandable near the Book CTA opening the refund-rules text where the data exists; styled consistently.

## 3. Core Web Vitals Cluster (fast = premium)

Targets: LCP <= 2.5s, CLS <= 0.1 (home + product, measured with Playwright/Lighthouse in the verification step; record results in docs).

1. **Hero image (LCP):** current `hotel_header_image_1776418446.jpg` is 1200x784 q90 JPEG served via CSS `background-image`. Replace with an optimized version: WebP/AVIF with JPEG fallback, <= 400KB, sized for the viewport (>=1920w for desktop hero); serve via an `<img>` with `fetchpriority="high"` where the template allows (or preloaded CSS background), NEVER lazy-loaded. Bundled into the media-pass step of `premium-search-hero`.
2. **Font preload:** add `<link rel="preload" as="font">` for the Fraunces + Manrope woff2 files in header.tpl (they are already self-hosted with `font-display: swap`); verify no FOUT layout shift; consider `size-adjust` fallback metrics if shift persists.
3. **CLS audit:** ensure every image in gallery, testimonials, room cards, and utility surfaces has `width`/`height` or CSS `aspect-ratio` (cards already use aspect-ratio 4/3 and 16/10 — extend to the product gallery + testimonial block); no late-injected banners above the fold; sticky header height is fixed (already a token `--fh-header-h`).
4. **Payload discipline:** no new JS libraries (lightbox = vanilla, <2KB); icon sprite < 15KB gz; total added CSS/JS within farmhouse targets (added JS <25KB gz, added CSS <30KB gz); audit transferSize before/after in the verification step.

## 4. Acceptance Criteria

- Review-score chips render on listing/home cards from real module data (hidden when 0 reviews); product rating row + reviews tab polished; no vendor-module logic modified (integration via hooks/custom module only).
- Factual scarcity line in booking widget uses real stock only; free-cancellation pill shown only where refund rules support it.
- Price-per-night + tax labels correct; gallery shows count badge and opens a working keyboard-accessible vanilla lightbox.
- Hero image optimized (WebP/AVIF + fallback, <=400KB, fetchpriority, not lazy); fonts preloaded; no CLS > 0.1 measured; weight audit recorded in docs.
- Regression: full search → category → product → cart flow intact; no console errors; 375/768/1440 no overflow; caches cleared; atomic Conventional Commits on feature/rural-marketplace-alpha.