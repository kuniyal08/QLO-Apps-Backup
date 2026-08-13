---
plan name: Surface-Footer-Fix
plan description: Unify homepage and footer
plan status: active
---

## Idea
Correct the Rural UP homepage’s clipped, mismatched section surfaces and replace the remaining partial stock footer with a cohesive Booking.com-inspired utility footer. The user approved a mostly continuous paper page flow: Featured Stays, Regions, Activities, and Stories share the inherited paper background; only Benefits and Testimonials receive restrained tonal bands. First neutralize the inherited Bootstrap row overflow at the homepage shell rather than hiding it, remove redundant paper-panel declarations, and preserve full-width intentional bands. Then rebuild the footer as an accessible travel utility area with practical link columns, support, account/trip links, payment confidence, newsletter where configured, language/currency hooks, legal/copyright bottom bar, and all existing QloApps footer hooks preserved. Validate live at 375/768/1440 and pause after the visible surface/footer correction.

## Implementation
- Inspect the live homepage DOM and computed widths to record the inherited Bootstrap row overflow and verify all correction selectors remain homepage-scoped.
- Neutralize `#index #columns > .row` negative margins and restore a width-consistent `#center_column`/`.ru-home` scaffold; remove reliance on `overflow-x:hidden` as the layout fix and recheck all desktop/tablet/mobile widths.
- Apply the approved continuous-paper rhythm: make paper sections transparent/inherited, retain only Benefits and Testimonials as subtle tonal bands, and remove any inherited module backgrounds/margins from the rebuilt section roots.
- Rebuild the footer wrapper around preserved hook output with a Booking.com-inspired utility hierarchy: Rural UP support/brand, Explore, Plan and manage, Help, newsletter utility, payment confidence, language/currency, and legal/copyright bottom bar.
- Add or replace theme overrides for all visible footer providers and containers: social/language, payment information, notification/newsletter, navigation/discovery links, and payment marks; preserve nested hook invocation and valid list semantics.
- Scope footer CSS under the Rural UP footer structure so stock global footer selectors cannot create old column spacing, headings, or nested-list artifacts; implement responsive stacked columns and retain mobile safe-area behavior.
- Clear Smarty caches and validate live homepage/footer at 375/768/1440: computed scroll width equals viewport, section backgrounds flow as approved, no stock footer modules visibly remain, links/hook output render, and no Smarty/PHP errors occur.
- Present the corrected homepage/footer for approval and continue no downstream journey work until the user accepts this visual direction.

## Required Specs
<!-- SPECS_START -->
- Unified-Surfaces
<!-- SPECS_END -->