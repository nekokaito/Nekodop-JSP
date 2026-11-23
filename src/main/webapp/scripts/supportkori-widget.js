(function () {
    const openButton = document.getElementById('supportkori-open');
    const modal = document.getElementById('supportkori-modal');
    const iframe = document.getElementById('supportkori-frame');
    if (!openButton || !modal || !iframe) return;

    let parentUrl = window.location.href;
    let paymentId = null;
    try {
        const pageUrl = new URL(parentUrl);
        const paymentParam = pageUrl.searchParams.get('sk_payment');
        if (paymentParam && /^SKR-\d{10,17}-\d{1,4}$/.test(paymentParam)) paymentId = paymentParam;
        if (pageUrl.searchParams.has('sk_payment')) {
            pageUrl.searchParams.delete('sk_payment');
            history.replaceState(null, '', pageUrl.href);
        }
        parentUrl = pageUrl.href;
        if (parentUrl.length > 1800) parentUrl = pageUrl.origin + pageUrl.pathname;
    } catch (error) {
        // Keep the current URL as the return target if URL parsing is unavailable.
    }

    const iframeUrl = new URL('/widget/nekodop', 'https://supportkori.com');
    iframeUrl.searchParams.set('parent', parentUrl);
    if (paymentId) iframeUrl.searchParams.set('payment_id', paymentId);
    iframe.src = iframeUrl.href;

    function setOpen(isOpen) {
        modal.setAttribute('aria-hidden', String(!isOpen));
        document.body.classList.toggle('supportkori-modal-open', isOpen);
        if (isOpen) modal.querySelector('.supportkori-modal-close').focus();
        else openButton.focus();
    }

    openButton.addEventListener('click', function () { setOpen(true); });
    modal.querySelectorAll('[data-supportkori-close]').forEach(function (element) {
        element.addEventListener('click', function () { setOpen(false); });
    });
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape' && modal.getAttribute('aria-hidden') === 'false') setOpen(false);
    });
    window.addEventListener('message', function (event) {
        if (event.origin === 'https://supportkori.com' && event.source === iframe.contentWindow && event.data === 'close-sk-widget') {
            setOpen(false);
        }
    });

    if (paymentId) setOpen(true);
})();
