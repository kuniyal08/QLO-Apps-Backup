{*
* Farmhouse: premium CMS — prose typography + category index cards.
* Preserves the admin preview banner (admin-action-cms) and ad/adtoken JS vars.
*}

{block name='cms'}
	<div class="fh-cms">
	{if isset($cms) && !isset($cms_category)}
		{if !$cms->active}
			<div id="admin-action-cms" class="fh-alert fh-alert--warn">
				<p>
					<span>{l s='This CMS page is not visible to your customers.'}</span>
					<input type="hidden" id="admin-action-cms-id" value="{$cms->id}" />
					<input type="submit" value="{l s='Publish'}" name="publish_button" class="fh-btn fh-btn--primary fh-btn--sm"/>
					<input type="submit" value="{l s='Back'}" name="lnk_view" class="fh-btn fh-btn--ghost fh-btn--sm"/>
				</p>
				<p id="admin-action-result"></p>
			</div>
		{/if}
		<div class="fh-prose rte{if $content_only} content_only{/if}">
			{$cms->content}
		</div>
	{elseif isset($cms_category)}
		<div class="block-cms fh-cms">
			<h1 class="fh-account__title"><a href="{if $cms_category->id eq 1}{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}{else}{$link->getCMSCategoryLink($cms_category->id, $cms_category->link_rewrite)}{/if}">{$cms_category->name|escape:'html':'UTF-8'}</a></h1>
			{if $cms_category->description}
				<p class="fh-account__copy">{$cms_category->description|escape:'html':'UTF-8'}</p>
			{/if}
			{if isset($sub_category) && !empty($sub_category)}
				<p class="fh-eyebrow">{l s='List of sub categories in %s:' sprintf=$cms_category->name}</p>
				<ul class="fh-cms__list">
					{foreach from=$sub_category item=subcategory}
						<li>
							<a class="fh-card fh-cms__item" href="{$link->getCMSCategoryLink($subcategory.id_cms_category, $subcategory.link_rewrite)|escape:'html':'UTF-8'}">{$subcategory.name|escape:'html':'UTF-8'}</a>
						</li>
					{/foreach}
				</ul>
			{/if}
			{if isset($cms_pages) && !empty($cms_pages)}
			<p class="fh-eyebrow">{l s='List of pages in %s:' sprintf=$cms_category->name}</p>
				<ul class="fh-cms__list">
					{foreach from=$cms_pages item=cmspages}
						<li>
							<a class="fh-card fh-cms__item" href="{$link->getCMSLink($cmspages.id_cms, $cmspages.link_rewrite)|escape:'html':'UTF-8'}">{$cmspages.meta_title|escape:'html':'UTF-8'}</a>
						</li>
					{/foreach}
				</ul>
			{/if}
		</div>
	{else}
		<div class="fh-alert fh-alert--error">
			{l s='This page does not exist.'}
		</div>
	{/if}
	</div>
	{block name='cms_js_vars'}
		{strip}
			{if isset($smarty.get.ad) && $smarty.get.ad}
				{addJsDefL name=ad}{$base_dir|cat:$smarty.get.ad|escape:'html':'UTF-8'}{/addJsDefL}
			{/if}
			{if isset($smarty.get.adtoken) && $smarty.get.adtoken}
				{addJsDefL name=adtoken}{$smarty.get.adtoken|escape:'html':'UTF-8'}{/addJsDefL}
			{/if}
		{/strip}
	{/block}
{/block}