(function () {
    'use strict';

    var header = document.getElementById('header');
    if (!header) {
        return;
    }

    window.addEventListener('scroll', function () {
        header.classList.toggle('ru-scrolled', window.pageYOffset > 24);
    });

    document.addEventListener('click', function (event) {
        var toggle = event.target.closest('.ru-mobile-search-toggle');
        if (!toggle) {
            return;
        }
        var panel = toggle.closest('.fh-search-panel');
        var expanded = panel.classList.toggle('ru-search-expanded');
        toggle.setAttribute('aria-expanded', expanded ? 'true' : 'false');
    });
}());
