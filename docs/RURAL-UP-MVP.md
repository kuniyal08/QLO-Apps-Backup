# Rural UP MVP Theme

## Purpose

`themes/rural-up-theme` is an independent, responsive Rural UP MVP theme. It was copied from `themes/hotel-reservation-theme`; neither the default theme nor `my-farmhouse-child-theme` was changed.

## Included MVP Surfaces

- Shared header, footer, responsive mobile bottom navigation, buttons, forms, cards, focus treatment, and reduced-motion handling.
- Homepage hero, trust messaging, and styling for the existing QloApps search hook.
- Category/availability results, room detail, booking widget, cart, and account-required one-page checkout presentation.
- Existing booking forms, hooks, JavaScript selectors, Bootstrap collapse behavior, payment slots, and Smarty variables are retained.

## Activation

Activate `rural-up-theme` from the QloApps Back Office theme settings after visual review. Then set `PS_ALLOW_MOBILE_DEVICE` to `0` so the responsive theme is used for all device widths, and clear Smarty caches:

```sh
rm -rf cache/smarty/compile/* cache/smarty/cache/*
```

Do not switch the production theme before the booking journey is tested in the intended environment.

## Known MVP Boundaries

- Existing hotel-first search is preserved.
- Property-first results, favorites, advanced marketplace filters, maps, Indian payment gateway integration, and pay-at-property remain later phases.
- Brand wordmark is provisional: `Rural UP`.
- Placeholder editorial imagery has not been sourced in this initial code pass; the existing configured hero image remains in use until licensed assets are curated and documented.
