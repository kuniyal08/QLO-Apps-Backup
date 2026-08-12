{*
* Farmhouse: premium 404 — friendly copy + discovery links home.
*}

<div class="fh-404">
	<p class="fh-eyebrow">{l s='Lost in the countryside?'}</p>
	<h1 class="fh-404__code">404</h1>
	<h2 class="fh-404__title">{l s='Page not found'}</h2>
	<p class="fh-404__copy">
		{l s='We\'re sorry, but the page you\'re looking for has wandered off. Let\'s get you back to your stay.'}
	</p>
	<div class="fh-404__actions">
		<a class="fh-btn fh-btn--primary" href="{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}" title="{l s='Home'}">
			{l s='Back to Home'}
		</a>
		<a class="fh-btn fh-btn--ghost" href="{$link->getPageLink('category', true, NULL, 'id_category=2')|escape:'html':'UTF-8'}" title="{l s='Browse our stays'}">
			{l s='Browse our stays'}
		</a>
	</div>
</div>
