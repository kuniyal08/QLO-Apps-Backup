{*
* Farmhouse: premium sitemap — card sections.
* Preserves category-tree-branch/category-cms-tree-branch includes and all links.
*}

{capture name=path}{l s='Sitemap'}{/capture}

<div class="fh-account">
	<p class="fh-eyebrow">{l s='Everything in one place'}</p>
	<h1 class="fh-account__title">{l s='Sitemap'}</h1>

	<div class="fh-sitemap__grid">
		<section class="fh-card fh-sitemap__block">
			<h3 class="fh-auth__card-title">{l s='Our offers'}</h3>
			<ul class="fh-list">
				<li>
					<a href="{$link->getPageLink('new-products')|escape:'html':'UTF-8'}" title="{l s='View a new product'}">{l s='New products'}</a>
				</li>
				{if !$PS_CATALOG_MODE}
				{if $PS_DISPLAY_BEST_SELLERS}
					<li>
						<a href="{$link->getPageLink('best-sales')|escape:'html':'UTF-8'}" title="{l s='View top-selling products'}">{l s='Best sellers'}</a>
					</li>
				{/if}
					<li>
						<a href="{$link->getPageLink('prices-drop')|escape:'html':'UTF-8'}" title="{l s='View products with a price drop'}">{l s='Price drop'}</a>
					</li>
				{/if}
			</ul>
		</section>

		<section class="fh-card fh-sitemap__block">
			<h3 class="fh-auth__card-title">{l s='Your Account'}</h3>
			<ul class="fh-list">
				{if $is_logged}
					<li>
						<a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Manage your customer account'}">{l s='Your Account'}</a>
					</li>
					<li>
						<a href="{$link->getPageLink('identity', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Manage your personal information'}">{l s='Personal information'}</a>
					</li>
					<li>
						<a href="{$link->getPageLink('addresses', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='View a list of my addresses'}">{l s='Addresses'}</a>
					</li>
					{if $voucherAllowed}
						<li>
							<a href="{$link->getPageLink('discount', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='View a list of my discounts'}">{l s='Discounts'}</a>
						</li>
					{/if}
					<li>
						<a href="{$link->getPageLink('history', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='View a list of my orders'}">{l s='Order history'}</a>
					</li>
				{else}
					<li>
						<a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Authentication'}">{l s='Authentication'}</a>
					</li>
					<li>
						<a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Create new account'}">{l s='Create new account'}</a>
					</li>
				{/if}
				{if $is_logged}
					<li>
						<a href="{$link->getPageLink('index')}?mylogout" rel="nofollow" title="{l s='Sign out'}">{l s='Sign out'}</a>
					</li>
				{/if}
			</ul>
		</section>

		<section class="fh-card fh-sitemap__block">
			<h3 class="fh-auth__card-title">{l s='Categories'}</h3>
			<div class="tree_top">
				<a href="{$base_dir_ssl}" title="{$categoriesTree.name|escape:'html':'UTF-8'}"></a>
			</div>
			<ul class="tree fh-list">
			{if isset($categoriesTree.children)}
				{foreach $categoriesTree.children as $child}
					{if $child@last}
						{include file="$tpl_dir./category-tree-branch.tpl" node=$child last='true'}
					{else}
						{include file="$tpl_dir./category-tree-branch.tpl" node=$child}
					{/if}
				{/foreach}
			{/if}
			</ul>
		</section>

		<section class="fh-card fh-sitemap__block">
			<h3 class="fh-auth__card-title">{l s='Pages'}</h3>
			<ul class="fh-list">
				<li>
					<a href="{$categoriescmsTree.link|escape:'html':'UTF-8'}" title="{$categoriescmsTree.name|escape:'html':'UTF-8'}">{$categoriescmsTree.name|escape:'html':'UTF-8'}</a>
				</li>
				{if isset($categoriescmsTree.children)}
					{foreach $categoriescmsTree.children as $child}
						{if (isset($child.children) && $child.children|@count > 0) || $child.cms|@count > 0}
							{include file="$tpl_dir./category-cms-tree-branch.tpl" node=$child}
						{/if}
					{/foreach}
				{/if}
				{foreach from=$categoriescmsTree.cms item=cms name=cmsTree}
					<li>
						<a href="{$cms.link|escape:'html':'UTF-8'}" title="{$cms.meta_title|escape:'html':'UTF-8'}">{$cms.meta_title|escape:'html':'UTF-8'}</a>
					</li>
				{/foreach}
				<li>
					<a href="{$link->getPageLink('contact', true)|escape:'html':'UTF-8'}" title="{l s='Contact'}">{l s='Contact'}</a>
				</li>
				{if $display_store}
					<li class="last">
						<a href="{$link->getPageLink('stores')|escape:'html':'UTF-8'}" title="{l s='List of our stores'}">{l s='Our stores'}</a>
					</li>
				{/if}
			</ul>
		</section>
	</div>
</div>