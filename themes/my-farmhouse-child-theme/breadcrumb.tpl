{*
* Farmhouse: premium breadcrumb.
* Keeps the $smarty.capture.path source, the schema.org transform chain for
* anchors, and the search-results back link.
*}

<!-- Breadcrumb -->
{if isset($smarty.capture.path)}{assign var='path' value=$smarty.capture.path}{/if}
<nav class="fh-crumb" aria-label="{l s='Breadcrumb'}">
	<a class="fh-crumb__home" href="{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}" title="{l s='Return to Home'}">
		<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-home"/></svg>
		<span class="visually-hidden">{l s='Home'}</span>
	</a>
	{if isset($path) AND $path}
		<span class="fh-crumb__pipe"{if isset($category) && isset($category->id_category) && $category->id_category == (int)Configuration::get('PS_ROOT_CATEGORY')} style="display:none;"{/if} aria-hidden="true">
			<svg class="fh-ic"><use href="#fh-ic-chevron-right"/></svg>
		</span>
		{if $path|strpos:'span' !== false}
			<span class="fh-crumb__page">{$path|@replace:'<a ': '<span itemscope itemtype="http://data-vocabulary.org/Breadcrumb"><a itemprop="url" '|@replace:'data-gg="">': '><span itemprop="title">'|@replace:'</a>': '</span></a></span>'}</span>
		{else}
			<span class="fh-crumb__page">{$path}</span>
		{/if}
	{/if}
</nav>
{if isset($smarty.get.search_query) && isset($smarty.get.results) && $smarty.get.results > 1 && isset($smarty.server.HTTP_REFERER)}
<div class="fh-crumb__back">
	<strong>
		{capture}{if isset($smarty.get.HTTP_REFERER) && $smarty.get.HTTP_REFERER}{$smarty.get.HTTP_REFERER}{elseif isset($smarty.server.HTTP_REFERER) && $smarty.server.HTTP_REFERER}{$smarty.server.HTTP_REFERER}{/if}{/capture}
		<a href="{$smarty.capture.default|escape:'html':'UTF-8'|secureReferrer|regex_replace:'/[\?|&]content_only=1/':''}" name="back">
			{l s='Back to Search results for "%s" (%d other results)' sprintf=[$smarty.get.search_query,$smarty.get.results]}
		</a>
	</strong>
</div>
{/if}
<!-- /Breadcrumb -->