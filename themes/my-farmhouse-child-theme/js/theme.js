/* ==========================================================================
   Farmhouse theme.js — vanilla interactions for the redesign.
   Loaded with `defer`. New interactions only; existing QloApps JS contracts
   (occupancy.js / product.js / order-opc.js / wk-room-search-block.js) are
   left untouched. Date quick-links integrate with the existing
   dateRangePicker instances via window.jQuery (already on page).
   ========================================================================== */
(function () {
  'use strict';

  // jQuery is loaded by stock scripts in the footer; resolve it lazily.
  function jq() {
    return window.jQuery || null;
  }

  var doc = document;
  var hasReducedMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  function ready(fn) {
    if (doc.readyState !== 'loading') {
      fn();
    } else {
      doc.addEventListener('DOMContentLoaded', fn);
    }
  }

  /* ----------------------------------------------------------------------
     Sticky header elevation on scroll
     ---------------------------------------------------------------------- */
  ready(function () {
    var sticky = doc.querySelector('.fh-header-sticky');
    if (!sticky) return;

    function onScroll() {
      sticky.classList.toggle('fh-header-sticky--scrolled', window.scrollY > 8);
    }

    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
  });

  /* ----------------------------------------------------------------------
     Footer accordions (phone only)
     ---------------------------------------------------------------------- */
  ready(function () {
    var heads = doc.querySelectorAll('.fh-footer-acc__head');
    if (!heads.length) return;

    Array.prototype.forEach.call(heads, function (head) {
      head.addEventListener('click', function () {
        var block = head.closest('.fh-footer-acc');
        if (!block) return;
        block.classList.toggle('fh-footer-acc--open');
        head.setAttribute('aria-expanded', block.classList.contains('fh-footer-acc--open') ? 'true' : 'false');
      });
      head.setAttribute('aria-expanded', 'false');
    });
  });

  /* ----------------------------------------------------------------------
     Date quick-link chips (search panel + booking widget)
     data-fh-quick="today|tomorrow|plus2|weekend"
     ---------------------------------------------------------------------- */
  ready(function () {
    var chips = doc.querySelectorAll('[data-fh-quick]');
    if (!chips.length) return;

    function fmt(d) {
      var dd = ('0' + d.getDate()).slice(-2);
      var mm = ('0' + (d.getMonth() + 1)).slice(-2);
      var yyyy = d.getFullYear();
      return dd + '-' + mm + '-' + yyyy;
    }

    function iso(d) {
      var dd = ('0' + d.getDate()).slice(-2);
      var mm = ('0' + (d.getMonth() + 1)).slice(-2);
      return d.getFullYear() + '-' + mm + '-' + dd;
    }

    function datesFor(kind) {
      var today = new Date();
      today.setHours(0, 0, 0, 0);
      var from = new Date(today);
      var to = new Date(today);

      switch (kind) {
        case 'today':
          to.setDate(to.getDate() + 1);
          break;
        case 'tomorrow':
          from.setDate(from.getDate() + 1);
          to.setDate(to.getDate() + 2);
          break;
        case 'plus2':
          from.setDate(from.getDate() + 2);
          to.setDate(to.getDate() + 3);
          break;
        case 'weekend':
          // Friday -> Sunday, or next Friday if past
          while (from.getDay() !== 5) from.setDate(from.getDate() + 1);
          to = new Date(from);
          to.setDate(to.getDate() + 2);
          break;
        default:
          return null;
      }
      return { from: from, to: to };
    }

    Array.prototype.forEach.call(chips, function (chip) {
      chip.addEventListener('click', function (e) {
        e.preventDefault();
        var dates = datesFor(chip.getAttribute('data-fh-quick'));
        if (!dates) return;

        var scope = chip.closest('[data-fh-datepicker]') || doc;
        var trigger = scope.querySelector('#daterange_value');
        var $ = jq();
        var picker = trigger && $ && $(trigger).data('dateRangePicker');

        if (picker && typeof picker.setDateRange === 'function') {
          picker.setDateRange(fmt(dates.from), fmt(dates.to));
        } else {
          // Fallback: fill hidden inputs + visible labels directly.
          var inTime = scope.querySelector('#check_in_time');
          var outTime = scope.querySelector('#check_out_time');
          if (inTime) inTime.value = iso(dates.from);
          if (outTime) outTime.value = iso(dates.to);
          var fromEl = scope.querySelector('#daterange_value_from span');
          var toEl = scope.querySelector('#daterange_value_to span');
          if (fromEl) fromEl.textContent = fmt(dates.from);
          if (toEl) toEl.textContent = fmt(dates.to);
        }

        Array.prototype.forEach.call(chips, function (c) {
          c.classList.toggle('fh-chip--active', c === chip);
        });
      });
    });
  });

  /* ----------------------------------------------------------------------
     Search submit loading state (button spinner)
     ---------------------------------------------------------------------- */
  ready(function () {
    var form = doc.getElementById('search_hotel_block_form');
    if (!form) return;

    form.addEventListener('submit', function () {
      var btn = doc.getElementById('search_room_submit');
      if (!btn) return;
      var label = btn.querySelector('span');
      var orig = label ? label.textContent : btn.textContent;
      btn.classList.add('fh-btn--loading');
      btn.setAttribute('disabled', 'disabled');
      if (label) label.textContent = 'Searching\u2026';
      else btn.textContent = 'Searching\u2026';
      btn.setAttribute('data-fh-orig', orig);
    });
  });

  /* ----------------------------------------------------------------------
     Mobile booking bottom bar -> sheet (room page)
     ---------------------------------------------------------------------- */
  ready(function () {
    var bar = doc.querySelector('.fh-bottom-bar');
    var sheet = doc.getElementById('fh-booking-sheet');
    if (!bar || !sheet) return;

    var openBtn = bar.querySelector('[data-fh-open-sheet]');
    var closeBtn = sheet.querySelector('.fh-sheet__close');
    var handle = sheet.querySelector('.fh-sheet__handle');

    function setSheet(open) {
      sheet.classList.toggle('fh-sheet--open', open);
      doc.body.classList.toggle('fh-drawer-locked', open);
      if (!open && openBtn) openBtn.focus({ preventScroll: true });
    }

    if (openBtn) openBtn.addEventListener('click', function () { setSheet(true); });
    if (closeBtn) closeBtn.addEventListener('click', function () { setSheet(false); });
    if (handle) handle.addEventListener('click', function () { setSheet(false); });
    doc.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') setSheet(false);
    });
    sheet.addEventListener('click', function (e) {
      if (e.target === sheet) setSheet(false);
    });
  });

  /* ----------------------------------------------------------------------
     Search stays pill (phone hero) -> expand search panel
     ---------------------------------------------------------------------- */
  ready(function () {
    var pill = doc.querySelector('[data-fh-search-pill]');
    var panel = doc.querySelector('[data-fh-search-panel]');
    if (!pill || !panel) return;

    pill.addEventListener('click', function () {
      panel.classList.toggle('fh-search-panel--expanded');
      var expanded = panel.classList.contains('fh-search-panel--expanded');
      pill.setAttribute('aria-expanded', expanded ? 'true' : 'false');
      if (expanded) {
        setTimeout(function () {
          var first = panel.querySelector('input, select, button');
          if (first) first.focus({ preventScroll: true });
        }, hasReducedMotion ? 0 : 200);
      }
    });
  });
})();
