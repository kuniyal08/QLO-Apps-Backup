# Competitor Research: Premium Hotel-Booking Frontends

> Companion research for plans `premium-home-pass` (specs `premium-search-hero`, `premium-trust-conversion`)
> and `rural-discovery-platform` (spec `farmstay-discovery`).
> Last reviewed: 2026-08-12. Purpose: evidence base for the farmhouse redesign and the rural discovery platform.

## 1. The industry-standard search schema (four fields)

All major OTAs converge on the same search schema — location → date range → guests/rooms → Search:

| Site | Pattern | Notable details |
|------|---------|-----------------|
| **Booking.com** | Single horizontal white bar with 4 inputs: destination (single text field w/ autocomplete), dates as **one grouped range control**, occupancy counter defaulting to "2 adults · 0 children · 1 room", Search button | Fields are *segments of one bar* separated by hairlines, not separate boxes; generous padding (Fitt's law); "I'm flexible" link under the bar; trust line under the bar |
| **Airbnb** | Compact pill bar in nav: "Anywhere \| Any week \| Add guests" + circular brand-color magnifier button | Segments expand into popover; flexible defaults reduce friction; steppers with logical constraints |
| **MakeMyTrip / Agoda / Expedia** | Same 4-field schema in a white rounded box | MMT widely criticized for clutter (see case studies below) |

**A/B evidence (GoodUI, Booking experiments):**
- A single search bar beats two ("Two Search Bars Are Not Better Than One", Leak 46).
- Single-line bar with minimal inter-field padding beat a multi-line form (variant rejected).
- Exposing adults/children/rooms counts directly in the bar won over hiding rooms in a dropdown.
- Location/destination tiles higher on the page performed better than other content.

**Sources:** GoodUI reverse-engineering of Booking homepage (goodui.org/blog/reverse-engineering-booking-coms-homepage-design-optimizations/); GoodUI leak archives (goodui.org/leaks/booking.com-ab-tested-single-vs-multiple-line-search-forms/, goodui.org/leaks/booking-a-b-tested-3-search-bars-challenging-the-fewer-form-fields-pattern/, goodui.org/leaks/booking-discovers-that-two-search-bars-are-not-better-than-one/, goodui.org/leaks/bookings-a-b-test-reveals-more-impactful-search-criteria-higher-location-tiles/); "The traveller Booking.com was built for" (bokangsibolla.com); Baymard case study (baymard.com/ux-benchmark/case-studies/booking-com); IXD@Pratt Airbnb critique (ixd.prattsi.org/2021/09/design-critique-airbnb-website/).

## 2. Why Booking.com reads as premium (eye-tracking & UX studies)

- One main image per viewport; scarce text; the search widget is the primary content with the highest luminance contrast (EyeQuant model, eye-tracking studies in AJHTL 9(2) 2020 — users' first fixations land on the search engine area).
- Minimalism beats content density: "simple design of the Booking website obtains a significant preference" (AJHTL study vs Hoteles.com).
- Accessibility: key text >= 16px, contrast at AA/AAA; icon sets kept consistent (criticisms of Booking itself: inconsistent icons, inconsistent spacing — cited as things NOT to copy).

**Sources:** eyequant.com/resources/what-booking-com-can-teach-us-about-a-b-testing-strategy/; ajhtl.com/uploads/7/1/6/3/7163688/article_19_vol_9_2__2020_spain.pdf; medium.com/@smck87/analyzing-booking-com-a04763a99517 (design+accessibility analysis).

## 3. Trust, social proof & scarcity (conversion science)

- Booking's conversion system: **scarcity** ("Only 2 rooms left"), **social proof** ("Booked 5 times today", review scores/counts), **urgency** (genuine time constraints only), **status** (Genius loyalty badge + instant discount).
- **Regulatory caution (CMA/UK 2019, GVH/Hungary 2020):** manufactured or unverifiable scarcity claims were sanctioned. Post-2020, Booking moved to factual, neutral/green-toned scarcity tied to real stock; researchers found stock-based messages ("Only N rooms left") most effective AND most honest.
- Cornell Hospitality Research: review volume/score correlates with RevPAR — reviews are a revenue feature, not decoration.
- Review display: score + count together ("6,845 reviews, 8.4/10"); verified-guest-only reviews; recent reviews by default.

**Sources:** clarigital.com/codex/case-studies/booking-com-ab-testing/; octalysisgroup.com/case-studies/booking-com-conversion-science/; raw.studio/blog/how-booking-com-increased-website-conversion/; real.mtak.hu/231662 (scarcity perception study, N=247); assets.nextleap.app/submissions/Product-Teardown-Bookingcom-*.pdf.

## 4. Performance: "fast feels premium" (Core Web Vitals)

- Targets: LCP <= 2.5s, INP <= 200ms, CLS <= 0.1 (75th percentile, mobile first).
- Hotel-site LCP killers: oversized hero JPEGs (4MB+ are common), hero videos, sync Google Fonts. Fix: WebP/AVIF, <= 150–400KB hero, `fetchpriority="high"`, never lazy-load the hero, right-size per viewport.
- CLS killers: images without width/height or aspect-ratio, late-injected banners/chat widgets, booking-widget iframes, web-font FOUT. Fix: reserve space, `aspect-ratio`, font preload + `font-display: swap` with matched fallback metrics.
- INP killers: heavy booking-widget JS bundles, synchronous third-party tags. Fix: keep widgets off the critical path, load placeholders, audit scripts.
- Real-world travel case study: JS payload 920KB→372KB, LCP 4.9→2.4s, CLS 0.19→0.05, INP 438→178ms via image sizing, lazy-loading, and removing heavy widgets from critical path.

**Sources:** hotelsseo.com/blog/core-web-vitals-hotels-2026-guide; digitalfoxllc.com/blog/core-web-vitals-for-hotels.html; logic-leap.co.uk/blog/core-web-vitals-hospitality-sites; web.dev/articles/optimize-cls + web.dev/articles/cls; softaims.com/casestudy/react/advanced-react-travel-booking.

## 5. Cheap-vs-premium design heuristics (synthesis of design audits)

1. **Grouped controls beat boxed fields.** A single control with hairline segment dividers reads as a product; separate bordered boxes with gaps read as a dashboard form.
2. **Whitespace is confidence.** Premium sites let content breathe on a consistent spacing rhythm (8pt); cheap sites fill every pixel.
3. **Color discipline.** One neutral base + 1–2 accents used sparingly; too many colors/gradients = amateur.
4. **Typography.** One display + one body font; generous sizes (body >= 16px, line-height 1.4–1.65); tuned letter-spacing; avoid uppercase 12px labels on primary inputs; avoid default/system fonts.
5. **Consistency.** Uniform radii, shadows, alignment and icon style; "a few pixels off" reads as cheap. Never mix icon sets (stroke weight + corner radius + detail all differ).
6. **Micro-interactions.** Hover/focus states, motion on transform/opacity only, `prefers-reduced-motion` respected; WCAG AA contrast; visible focus rings.
7. **Imagery.** Curated, authentic photography; one hero image; gradient overlays for text legibility.

**Sources:** webwavers.de/en/blog/website-design-elemente-premium; switchsolutions.com/how-typography-affects-guest-experience/; fontkingdom.com/typography-tips-for-luxury-hotels; medium.com/design-bootcamp/how-i-redesigned-makemytrips-hotel-booking-flow (clutter critique); linkedin.com/posts/akhil-n (Agoda clutter critique).

## 6. Icon system decision

| Set | Coverage | License | Style | Verdict |
|-----|----------|---------|-------|---------|
| Lucide | ~1,500 | ISC | 24px grid, 2px stroke, `currentColor` | Strictest consistency; minimal |
| Tabler | ~5,000+ | MIT | 24px grid, 2px stroke | Largest coverage; outline+filled |
| Phosphor | ~1,500 concepts x6 weights | MIT | 256 grid, filled paths | Weight-as-token; heavy grid |

**Decision:** one MIT/ISC stroke set (Tabler or Lucide), 24px/2px, self-hosted as an inline SVG sprite (20–30 icons max), `currentColor`, LICENSE file included, target < 15KB gz. Never mix sets (mixing is the most common cause of "subtly wrong" UIs). FontAwesome Free (CC BY 4.0, attribution required) is being replaced in farmhouse components.

**Sources:** svgicons.com/articles/lucide-vs-tabler-vs-phosphor-icons; github.com/tabler/tabler-icons; iconoop.com/icon-sets.html; blog.openreplay.com/svg-icon-libraries-web-apps; mantlr.com/blog/best-open-source-icon-libraries-compared; youngju.dev/blog/culture/2026-05-16-icon-libraries-...; phosphoricons.com.

## 7. Royalty-free media sources (licensing notes)

- **Unsplash License:** free for commercial/editorial use, no attribution required (appreciated), irrevocable. Restrictions: cannot compile images to replicate a competing stock service; **no model/property releases** — the user assumes all risk with recognizable people and trademarked buildings.
- **Pexels License:** same free-commercial terms; cannot sell/distribute standalone; same release caveats.
- **Pixabay:** similar, mixed CC0 + Pixabay License.
- **Guidance for this project:** use images without recognizable faces or distinctive landmarks; prefer rural-UP farmhouse subjects (mud courtyards, harvest fields, verandas, local hospitality); self-host downloads (never hotlink); document the source per image.

**Sources:** help.unsplash.com/en/articles/2612315 (commercial use); help.pexels.com/hc/en-us/articles/360042295174 (license); licenseorg.com/blog/free-stock-photos-licensing-traps; licenseorg.com/compare/pexels-vs-unsplash.

## 8. Mapping to the QloApps farmhouse theme (constraints)

- **Preserve:** every wkroomsearchblock field id/name (hotel_location, location_category_id, check_in_date, check_out_date, adult_count, child_count, number_of_rooms, search_room_submit), classes (header-rmsearch-input, input-date, daterange_value_from/to, guest_occupancy), hooks (displaySearchFormFieldsBefore/After), datepicker + Bootstrap dropdown + autocomplete JS contracts. The Booking-style restyle is **CSS-only**.
- **Trust data that already exists:** `qlohotelreview` module (active) — `QhrHotelReview::getAverageRatingByIdHotel()` / `getReviewCountByIdHotel()` (cached); review tab via HOOK_PRODUCT_TAB; rating hook displayRoomTypeDetailRoomTypeNameAfter on product page. Scarcity: real stock vars (`total_available_rooms`, `max_avail_type_qty`) in the booking widget — use only for factual lines.
- **Cancellation data:** `HotelOrderRefundRules` (hotelreservationsystem) — free-cancellation pill only where rules support it.
- **Performance:** cards already use aspect-ratio (4/3, 16/10); fonts self-hosted with swap; remaining: hero image optimization, font preload, gallery CLS, payload audit.
- **Ethics:** no manufactured scarcity/urgency claims (CMA/GVH precedent); neutral factual tone only.

## 9. Gaps currently out of scope (future workstreams)

- Listing sort/filter bar (Baymard's "most heavily optimized surface") — deferred.
- Wishlist/save, recently-viewed, personalized recommendations.
- OG/meta + Hotel/Room structured data; logged-in greeting.

## 10. Airbnb's design language system (clean-modern evidence base)

Airbnb's public DLS is the reference for the client-confirmed "clean modern" direction:

- **Restraint is the system:** ONE typeface (Airbnb Cereal — a grotesque with weight-only hierarchy, no serif display); ONE accent color (Rausch red #FF385C) reserved almost exclusively for primary actions and the brand mark; everything else is ink/neutrals.
- **Geometry:** soft rounded corners everywhere — 8px buttons, 12–20px cards, pill search bar and category chips, circular avatars/buttons; depth comes from photography + whitespace, NOT heavy shadows (Airbnb cards are effectively shadowless with hairline borders).
- **Spacing:** 4/8px grid base; generous vertical rhythm; large left/right gutters.
- **Categories pattern:** the horizontal icon-chip strip (types of stays / experiences) replaced filter-first discovery — one tap into a curated subset, great for inventory with strong differentiation (fits our region/activity discovery).
- **Trust infrastructure:** verified reviews with multi-dimensional ratings, total-price transparency ("$x total"), free-cancellation framing per listing.
- **The DLS's own caveat:** the system "assumes high-quality photography exists"; without it, visual hierarchy collapses. Our response: typography-first surfaces (color-block + monogram placeholders) carry cards instead of photos.

**Sources:** airbnb.design (design system essays); medium.com/airbnb-design/design-systems (DLS write-ups); casework on Airbnb search/browse patterns (ixd.prattsi.org/2021/09/design-critique-airbnb-website/).

## 11. UP government context — the platform's positioning advantage

- **UP Farm Stay investment drive (Sept 2025):** UP Tourism invited investment in farm stays with >= 2 lettable rooms, a reception area, and *rural activities* — agri-farming, horticulture, fishponds, dairy, animal husbandry, farm tours. Capital-subsidy support and single-window clearances announced; aligned with the government's agri-tourism / "reverse migration" push.
- **B&B / Homestay Policy 2025:** registration-based approval under the UP tourism portal (up-tourismportal.in), small-operator friendly — the model for many of our government/developed properties.
- **Scale:** UP hosted ~65 crore tourist visits in 2024; thematic tourism tracks include rural, wildlife/nature-eco, adventure, heritage — regions like Bundelkhand, Awadh, Braj, Purvanchal, Rohilkhand and the Kashi region each carry distinct stay-and-do identities.
- **Design consequence:** the site presents as the booking face of a real government initiative — trust-led, editorial voice, "stay + do" (farmstay + local activity) framing, government-property friendly. Region and activity discovery are therefore first-class navigation, not blog content.

**Sources:** UP tourism portal announcements 2025 (farm stay investment drive, B&B/Homestay Policy 2025); press coverage of UP tourism figures 2024/2025.

## 12. Adaptation: typography-first + hybrid imagery (supersedes the media pass)

- **Client decision (2026-08-12):** clean modern, refined farmhouse palette (forest green #2F4A3C on cream #F7F4EF), and **hybrid imagery** — real royalty-free photos (Unsplash/Pexels, self-hosted in the theme) for hero + region/blog/editorial surfaces ONLY (clearly decorative), and designed monogram/color-block SVG placeholders for property cards (no photo may imply a specific stay exists).
- This supersedes the curated-hero-photo work item of plan `premium-home-pass` (its icon-system and trust/conversion items remain).
- Card design therefore leads with typography: Fraunces display for names, monogram tiles, hairline borders, one accent (forest green) for primary actions — the Airbnb model adapted to a photography-less inventory.
