# Spec: Unified-Brand

Scope: feature

# Rural UP Unified Brand System

## Scope
Every visible customer-facing Rural UP surface must use one coherent logo, typography, icon, and control language. This specification supersedes the narrow Header-Polish scope. It applies to homepage, navigation/drawer, mobile bottom navigation, search, discovery, property/results, room detail, booking forms, cart, checkout, payment/confirmation, account/auth, help/CMS/legal/system pages, footer, and all active theme/module template output.

## Typography
- Display: self-hosted Rural UP editorial serif used consistently for display headings, card titles where appropriate, and major editorial statements.
- UI/body: self-hosted modern sans used consistently for controls, labels, navigation, body copy, facts, prices, and operational text.
- Do not expose generic Arial, Georgia, stock Oxygen, or unplanned browser fallbacks as a visible deliberate style.
- Define and use one documented type scale, weights, line heights, casing, tracking, and responsive behavior.
- Preserve English-first translation patterns and allow future Hindi/Devanagari fallback without clipping, fixed text widths, or broken layouts.

## Logo and Marks
- Rural UP wordmark/lockup is the sole customer-facing platform logo until official branding is supplied.
- Use one responsive wordmark treatment across desktop header, mobile header, footer, confirmation/support surfaces, and system pages.
- No accidental module logos, stock QloApps/PrestaShop marks, generic brand text, or inconsistent lockups may appear in visible customer UI.
- Do not imply Uttar Pradesh government endorsement through seals, emblems, or official-looking insignia.

## Icon System
- Build one self-hosted Rural UP SVG stroke icon sprite on a consistent 24px grid, using `currentColor`, a single stroke weight, semantic labels, and accessible decoration rules.
- Required icons: cart, chevron down/up, menu, close, user/account, mail, phone, search, calendar, guests, home, stays/search, trips, arrow right, check, location, plus, minus, remove, external/link, and status/support marks.
- Replace every visible Font Awesome/icon-font glyph, CSS pseudo-icon, Unicode icon, stock blue menu glyph, and mixed SVG family in customer UI.
- The visible cart must be semantic SVG markup in the theme blockcart override, not CSS-generated Font Awesome pseudo-elements. Preserve cart URL, `ajax_cart_quantity`, `ajax_cart_no_product`, `ajax_cart_total`, dropdown content, layer-cart, keyboard behavior, and AJAX updates.
- The visible account, drawer, contact, footer, search, booking controls, occupancy/quantity steppers, ratings where data exists, and mobile navigation must use the same icon family.
- Legacy icon fonts may remain loaded only for hidden runtime/provider behavior until tested replacement. Document each exception.

## Shell and Control Consistency
- Header is a deliberate flex layout, not overlapping Bootstrap 7/12 + 5/12 + additional menu siblings.
- Brand, support, account, cart, cart badge, cart chevron, and drawer share 40-44px hit areas, one baseline, and consistent spacing.
- Header contact bar uses the same SVG system or text-only treatment, never separate Font Awesome styling.
- Menu/drawer and close controls use Rural UP forest/paper tones, never stock Webkul blue.
- Mobile bottom navigation uses the same SVG family, not Unicode characters.
- Payment-provider trademarks and hosted gateway interfaces are exceptions: retain recognizable legal/functional brand marks but wrap them in Rural UP layout and typography.

## Page Rhythm
- Homepage must use controlled spacing tokens, not legacy cumulative padding.
- Reconcile hero/search overlap, `columns-container`, `#columns:has(#center_column > *)`, section padding, and pre-footer spacing without clipping or overflow suppression.
- The mostly continuous paper homepage flow remains approved; only intentional benefit/proof bands may use restrained tonal surfaces.

## Preservation Rules
- Keep all QloApps hooks, Smarty variables, translation calls, form IDs/names, data attributes, Bootstrap behavior selectors, payment hooks, booking selectors, AJAX fragments, cart counters, and module insertion points.
- Theme overrides only: do not modify core/module logic to achieve visual consistency.
- Never redraw or alter third-party payment trademarks.

## Acceptance
- A complete customer-route UI inventory exists, with every visible logo/font/icon classified and migrated or documented as a provider exception.
- No visibly mixed icon families, generic font treatment, stock blue controls, CSS-generated Font Awesome cart/caret, or Unicode navigation icons remain in Rural UP customer UI.
- Font and icon assets load locally with no broken references.
- QA at 375px, 768px, and 1440px confirms alignment, contrast, keyboard focus, 44px controls, no horizontal overflow, no console/Smarty/PHP errors, and preserved search/cart/booking/checkout interactions.
- The final system is documented with asset provenance, license records, typography rules, SVG usage, provider exceptions, and future official-brand swap points.