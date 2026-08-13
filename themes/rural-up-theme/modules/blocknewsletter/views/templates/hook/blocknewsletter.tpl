<section id="blocknewsletter" class="ru-footer-newsletter">
    <p class="ru-eyebrow">{l s='Keep in touch' mod='blocknewsletter'}</p>
    <h3>{l s='Slow travel, sent occasionally.' mod='blocknewsletter'}</h3>
    <form action="{$link->getModuleLink('newsletter', 'subscription')|escape:'html':'UTF-8'}" method="post">
        <input type="hidden" name="ajax" value="1" />
        <input type="hidden" name="action" value="SubscribeNewsletter" />
        <input type="hidden" name="token" value="{$csrf_token}" />
        <input type="hidden" name="newsletter_action" value="0" />
        <label class="sr-only" for="newsletter-input">{l s='Your email address' mod='blocknewsletter'}</label>
        <input class="newsletter-input" id="newsletter-input" name="email" placeholder="{l s='Your email address' mod='blocknewsletter'}" type="email" />
        <button name="submitNewsletter" type="submit">{l s='Subscribe' mod='blocknewsletter'}</button>
        <div class="message-block" style="display:none;"></div>
        {if isset($id_module)}{hook h='displayGDPRConsent' id_module=$id_module}{/if}
        {hook h='displayNewsletterFormFieldsAfter'}
    </form>
    {hook h="displayBlockNewsletterBottom" from='blocknewsletter'}
</section>
