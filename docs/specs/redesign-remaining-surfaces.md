# Spec: redesign-remaining-surfaces

Scope: feature

# Remaining Redesign Surfaces

Scope: feature. Companion to plan `complete-frontend-redesign`. Design tokens, brand, typography, hooks and JS contracts come from spec `farmhouse-design-system` (unchanged).

## Audit snapshot (already executed, verified on live site)

REDESIGNED (in place, keep): header chrome (sticky translucent, nav drawer, icon sprite), hero search panel (fh-search-panel--hero with search_hotel_block_form), homepage (hero, trust, regions/activities/blog discovery, interior/amenities/rooms blocks), product page (type-led hero cover, booking widget polish: per-night, scarcity, refund pill), room listings/our-properties (monogram covers, cards), footer SCAFFOLDING (footer.tpl structure with all hooks; the 4 CONTENT columns are still stock 2017 module templates).

STILL STOCK (targets of this plan):
- Footer content: blocksocial ("Follow us on" + empty social ul), wkfooterpaymentblock ("payment accepted"), wkfooternotificationblock ("GET NOTIFICATIONS / Subscribe"), footer links column ("Explore"), wkfooterlangcurrencyblock (lang/currency), wkfooterpaymentinfoblockcontainer — all render stock Bootstrap classes (footer-section-heading, margin-lr-0, hr, col-sm-3).
- Breadcrumb.tpl, pagination, page-heading/nav-tabs residue on shell pages.
- Authentication.tpl (login/register), my-account.tpl, my-account-form.tpl, identity.tpl, addresses.tpl + address.tpl, order-detail.tpl, history.tpl, guest-tracking.tpl, contact-form.tpl, cms.tpl, sitemap.tpl, stores.tpl, 404.tpl, errors.tpl, maintenance.tpl.
- Cart/checkout: order-opc.tpl flow — shopping-cart.tpl, _partials/order-room-detail.tpl, order-hotel-service-detail.tpl, order-standalone-service-detail.tpl, order-extra-services.tpl, cart_booking_demands.tpl, cart-total-block.tpl, order-steps.tpl, order-carrier.tpl, order-payment.tpl, order-opc-new-account.tpl, order-opc-edit-guest-info.tpl, order-confirmation.tpl.
- CSS: css/order-opc.css (~1009 lines) targets stock selectors (#order-opc .box etc.), not fh- classes; account.css/authentication.css have only partial fh- coverage. Rewrite templates with fh- markup, then extend/align these CSS files.

## Footer design (client-approved: branded replacement)

Single branded band under the explore strip, inside footer.tpl structure (DO NOT touch footer.tpl hook calls):
- Column 1: brand blurb ("Rural stays and local stories" + one-liner) — replaces blocksocial; drop empty social ul.
- Column 2: Explore — Regions / Activities / Stories (module links) + Our Properties.
- Column 3: Policies — Legal Notice, Terms, Privacy (existing CMS links; blockcms/legal content preserved via its own hook/module templates).
- Column 4: Contact — email/phone (stay@myfarmhousehotel.com / 0987654321) + secure payment marks (restyle wkfooterpaymentblock output).
- Unconfigured/empty blocks (social icons, subscribe) hidden when empty.
- Phone: columns collapse to accordion or stacked cards (no horizontal overflow).
- Implementation: theme overrides under themes/my-farmhouse-child-theme/modules/<provider>/ for blocksocial, wkfooterpaymentblock, wkfooterpaymentinfoblockcontainer, wkfooternotificationblock, wkfooterlangcurrencyblock, plus the footer-links provider (blockcms/blocknavigationmenu as found during audit). Where a provider renders unrelated content, scope its override to footer context only.

## Contract invariants (MUST preserve - from farmhouse-design-system spec)

- Search form id `search_hotel_block_form`, POST; fields hotel_location, location_category_id, check_in_date, check_out_date, adult_count, child_count, number_of_rooms; hooks displaySearchFormFieldsBefore/After — untouched (already done).
- booking-form contract: form name/id `booking-form`, hidden inputs, quantity/occupancy steppers, displayBookingAction — untouched.
- order-opc.tpl: keep its include structure ($opc branch, shopping-cart.tpl, order-opc-new-account.tpl, order-opc-edit-guest-info.tpl, order-carrier.tpl, order-payment.tpl, cart-total-block.tpl, errors.tpl) and the order-steps rendering used by order controllers.
- Cart rows: keep all displayCartRoomTypeInfo, displayCartProduct*/displayCartRoomTypeNameAfter/ImageAfter/ContentAfter/ContainerBottom/HotelLocationAfter, displayCartRoomImageAfter hooks; keep voucher input name; keep cart_booking_demands/order-room-detail partial include names.
- Checkout: HOOK_PAYMENT, HOOK_ADVANCED_PAYMENT, HOOK_TOP_PAYMENT, HOOK_EXTRACARRIER, HOOK_BEFORECARRIER, HOOK_ORDER_CONFIRMATION, displayOrderConfirmation, displayBeforeCartTotalTax, displayCartRightColumn, displayHotelBranchInformation hooks must keep rendering (emqCheckoutBlock WhatsApp, wkcheckoutpaymentblock).
- Account/auth: HOOK_CREATE_ACCOUNT_FORM/TOP, HOOK_CUSTOMER_ACCOUNT, HOOK_CUSTOMER_IDENTITY_FORM, displayCustomerAccountAfterTabs, displayContactFormFieldsAfter, displayForgotPasswordFormFieldsAfter preserved.
- Body/global: keep global.tpl JS includes (order-opc.js, occupancy.js, product.js, global.js untouched - styling only).

## Acceptance criteria

- Every page (home, discovery, category, product, cart, checkout, confirmation, auth, account, CMS, contact, 404) carries the farmhouse design language; no visually stock-2017 surfaces remain (page-heading, footer-section-heading, #order-opc stock boxes).
- Guest journey regression passes: search -> availability -> room -> occupancy -> cart -> checkout -> confirmation at 375/768/1440, no horizontal overflow, no console/PHP errors, 44px targets.
- Hook inventory renders: displayFooter*, displayHome*, displayCart*, HOOK_PAYMENT output, emq WhatsApp blocks present.
- Smarty caches cleared per change; module overrides synced via podman cp and baked into the image before final QA; commits atomic per surface.