{block name='footer_navigation'}
<section class="ru-footer-links">
    <p class="ru-eyebrow">{l s='Explore' mod='blocknavigationmenu'}</p>
    <h3>{l s='Make a plan' mod='blocknavigationmenu'}</h3>
    <ul class="footer-navigation-section">
        {if isset($navigation_links)}{foreach $navigation_links as $navigationLink}<li><a href="{$navigationLink['link']|escape:'html':'UTF-8'}">{$navigationLink['name']|escape:'html':'UTF-8'}</a></li>{/foreach}{/if}
        {block name='displayFooterExploreSectionHook'}{hook h="displayFooterExploreSectionHook"}{/block}
    </ul>
</section>
{/block}
