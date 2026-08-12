{*
* Farmhouse: premium footer navigation column (displayFooter).
* `$navigation_links` are admin-managed; policies/CMS links come through them.
*}
{block name='fh_footer_nav'}
{if isset($navigation_links) && $navigation_links}
	<div class="fh-footer-col fh-footer-col--nav">
		<p class="fh-footer-col__head">{l s='Explore' mod='blocknavigationmenu'}</p>
		<ul class="fh-footer-navlist">
			{foreach $navigation_links as $navigationLink}
				<li>
					<a href="{$navigationLink['link']|escape:'html':'UTF-8'}" title="{$navigationLink['name']|escape:'html':'UTF-8'}">{$navigationLink['name']|escape:'html':'UTF-8'}</a>
				</li>
			{/foreach}
		</ul>
	</div>
{/if}
{/block}