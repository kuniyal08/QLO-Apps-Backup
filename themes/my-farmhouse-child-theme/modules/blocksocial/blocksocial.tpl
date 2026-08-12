{*
* Farmhouse: branded footer brand column (replaces stock social block).
* Social icons render only when a URL is configured.
*}
{block name='fh_footer_brand'}
<div class="fh-footer-col fh-footer-col--brand">
	<p class="fh-footer-brand__eyebrow">{l s='Farmhouse stays' mod='blocksocial'}</p>
	<h4 class="fh-footer-brand__title">Rural stays &amp; local stories</h4>
	<p class="fh-footer-brand__blurb">{l s='Handpicked farmhouses across the countryside of Uttar Pradesh. Stay with families, eat from the land and wake up to open skies.' mod='blocksocial'}</p>
	<ul class="fh-footer-brand__contact">
		<li class="fh-footer-brand__contact-item">
			<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-phone"/></svg>
			<a href="tel:0987654321">0987654321</a>
		</li>
		<li class="fh-footer-brand__contact-item">
			<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-tag"/></svg>
			<a href="mailto:stay@myfarmhousehotel.com">stay@myfarmhousehotel.com</a>
		</li>
	</ul>
	{if isset($facebook_url) && $facebook_url || isset($twitter_url) && $twitter_url || isset($instagram_url) && $instagram_url}
		<ul class="fh-footer-brand__social">
			{if isset($facebook_url) && $facebook_url}<li><a class="fh-pill-link" href="{$facebook_url|escape:'html':'UTF-8'}" rel="noopener" target="_blank">{l s='Facebook' mod='blocksocial'}</a></li>{/if}
			{if isset($twitter_url) && $twitter_url}<li><a class="fh-pill-link" href="{$twitter_url|escape:'html':'UTF-8'}" rel="noopener" target="_blank">{l s='Twitter' mod='blocksocial'}</a></li>{/if}
			{if isset($instagram_url) && $instagram_url}<li><a class="fh-pill-link" href="{$instagram_url|escape:'html':'UTF-8'}" rel="noopener" target="_blank">{l s='Instagram' mod='blocksocial'}</a></li>{/if}
		</ul>
	{/if}
</div>
{/block}
