---
plan name: Header-Polish
plan description: Unify navigation and spacing
plan status: active
---

## Idea
Correct the remaining Rural UP homepage visual defects through a coherent header and page-rhythm pass before further downstream work. Replace the accumulated homepage whitespace with intentional editorial spacing: reduce hero-to-content gap by reconciling the absolute search overlap and legacy `#columns:has(#center_column > *)` padding, reduce repeated section boundary spacing from the current effective 176px to a controlled responsive rhythm, and remove excess pre-footer whitespace while preserving full-width surface flow. Rebuild the desktop and mobile header layout around theme-owned flex markup rather than conflicting Bootstrap 7/12 + 5/12 + third-sibling geometry. Replace every visible legacy/Font Awesome or Unicode icon in the header and mobile nav with one self-hosted SVG stroke icon system: cart, chevron, menu, close, account, mail, phone, search, home, trips, and arrow. Replace CSS-generated cart/caret glyphs with semantic SVG markup while preserving blockcart quantity and AJAX contracts. Restyle cart badge, account, help, drawer, contact bar, and mobile bottom navigation as consistent Rural UP controls. Use local Chrome screenshots/DOM/CSS inspection for QA; chrome-devtools-mcp may be added but is not needed to implement or validate this pass.

## Implementation
- Capture current live homepage/header screenshots and DOM at 375, 768, and 1440; measure the hero/search/content, inter-section, and pre-footer gaps and record the active legacy selectors responsible.
- Define a theme-owned SVG icon sprite with one consistent 24px stroke language; include cart, chevron, menu, close, user, mail, phone, home, stays/search, trips, and directional arrow; self-host it under the Rural UP theme with a license/source record.
- Replace blockcart header markup in the theme override with semantic SVG cart and chevron elements while retaining cart URL, `ajax_cart_quantity`, `ajax_cart_no_product`, totals, dropdown content, layer-cart behavior, and AJAX selectors; remove the visible Font Awesome pseudo-icons only after replacement markup exists.
- Rebuild the header top-row markup and CSS so brand, help, account, cart, and drawer use one explicit responsive flex layout; preserve QloApps displayNav/displayTop hooks and account/cart module output while eliminating Bootstrap sibling-width conflicts.
- Replace visible header contact, account, drawer, and mobile-bottom-navigation glyphs with the same SVG system; make all control hit areas 40-44px, keyboard-visible, and aligned on one baseline; restyle the drawer from stock blue to Rural UP forest/paper.
- Correct page rhythm at homepage scope: reconcile search overlap with `columns-container` and legacy `#columns:has()` padding, set intentional section spacing without cumulative 176px gaps, and reduce post-testimonial/footer whitespace without clipping or hiding layout defects.
- Clear Smarty caches and validate live at 375, 768, and 1440: no horizontal overflow, consistent header controls/icons, correct cart badge placement, drawer/account/cart behavior, search operation, and no console/Smarty/PHP errors.
- Present the polished homepage/header for user approval, then resume downstream booking work only after approval.

## Required Specs
<!-- SPECS_START -->
<!-- SPECS_END -->