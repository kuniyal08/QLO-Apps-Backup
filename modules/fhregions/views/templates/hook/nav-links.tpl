{*
* Farmhouse: discovery links for the nav drawer (displayDefaultNavigationHook).
*}

{block name='fh_discovery_nav_links'}
{if isset($fh_discovery_links) && $fh_discovery_links|@count}
	{foreach $fh_discovery_links as $discoveryLink}
		<li>
			<a class="navigation-link" href="{$discoveryLink.link|escape:'html':'UTF-8'}">{$discoveryLink.name|escape:'html':'UTF-8'}</a>
		</li>
	{/foreach}
{/if}
{/block}