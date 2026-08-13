{block name='fh_discovery_footer_links'}
{if isset($fh_discovery_links) && $fh_discovery_links|@count}
    {foreach $fh_discovery_links as $discoveryLink}
        <li><a href="{$discoveryLink.link|escape:'html':'UTF-8'}">{$discoveryLink.name|escape:'html':'UTF-8'}</a></li>
    {/foreach}
{/if}
{/block}
