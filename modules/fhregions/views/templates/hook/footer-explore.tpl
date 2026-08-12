{*
* Farmhouse: discovery links for the footer explore section
* (displayFooterExploreSectionHook).
*}

{block name='fh_discovery_footer_links'}
{if isset($fh_discovery_links) && $fh_discovery_links|@count}
	<ul class="fh-footer-explore__list">
		{foreach $fh_discovery_links as $discoveryLink}
			<li>
				<a class="fh-footer-explore__link" href="{$discoveryLink.link|escape:'html':'UTF-8'}">{$discoveryLink.name|escape:'html':'UTF-8'}</a>
			</li>
		{/foreach}
	</ul>
{/if}
{/block}