{*
* Farmhouse: stories listing with category filter.
* Informational editorial content - never bookable.
*}

{block name='fh_blog_listing'}
<div class="fh-blog fh-section">
	<div class="fh-container">
		<header class="fh-page-head">
			<p class="fh-eyebrow">{l s='Stories' mod='fhblog'}</p>
			<h1 class="fh-page-title">{l s='Stories from the countryside' mod='fhblog'}</h1>
			<p class="fh-page-subtitle">{l s='Farmstay diaries, village guides and the policy behind rural stays in Uttar Pradesh.' mod='fhblog'}</p>
		</header>

		{if isset($fh_blog_categories) && $fh_blog_categories|@count}
			<nav class="fh-filter-bar" aria-label="Filter by category">
				<a class="fh-filter-pill{if !$fh_blog_selected_category} fh-filter-pill--active{/if}" href="{$fh_blog_url|escape:'html':'UTF-8'}">{l s='All stories' mod='fhblog'}</a>
				{foreach $fh_blog_categories as $category}
					<a class="fh-filter-pill{if $fh_blog_selected_category == $category.id_blog_category} fh-filter-pill--active{/if}" href="{$fh_blog_url|escape:'html':'UTF-8'}&id_blog_category={$category.id_blog_category|intval}">{$category.name|escape:'html':'UTF-8'}</a>
				{/foreach}
			</nav>
		{/if}

		{if isset($fh_blog_posts) && $fh_blog_posts|@count}
			<div class="fh-blog-grid">
				{foreach $fh_blog_posts as $post}
					<article class="fh-card fh-blog-card">
						<a class="fh-blog-card__link" href="{$fh_blog_post_url|escape:'html':'UTF-8'}&id_blog_post={$post.id_blog_post|intval}" title="{$post.title|escape:'html':'UTF-8'}">
							<div class="fh-card__media">
								{if $post.cover}
									<img src="{$smarty.const._PS_IMG_}fhblog/{$post.cover|escape:'html':'UTF-8'}" alt="{$post.title|escape:'html':'UTF-8'}" width="640" height="360" loading="lazy">
								{else}
									<div class="fh-mono fh-mono--{$post.id_blog_category|intval}" aria-hidden="true">{$post.title|substr:0:1}</div>
								{/if}
							</div>
							<div class="fh-card__body fh-blog-card__body">
								<p class="fh-blog-card__meta">
									{if $post.category_name}<span class="fh-tag">{$post.category_name|escape:'html':'UTF-8'}</span>{/if}
									<span class="fh-blog-card__date">{dateFormat date=$post.date_add full=0}</span>
								</p>
								<h2 class="fh-blog-card__title">{$post.title|escape:'html':'UTF-8'}</h2>
								<p class="fh-blog-card__excerpt">{$post.excerpt|escape:'html':'UTF-8'}</p>
								<span class="fh-blog-card__read">{l s='Read story' mod='fhblog'}<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg></span>
							</div>
						</a>
					</article>
				{/foreach}
			</div>

			{if $fh_blog_page_count > 1}
				<div class="fh-pagination">
					{if $fh_blog_page > 1}
						<a class="fh-btn fh-btn--ghost" href="{$fh_blog_url|escape:'html':'UTF-8'}&id_blog_category={$fh_blog_selected_category|intval}&page={$fh_blog_page-1|intval}">{l s='Previous' mod='fhblog'}</a>
					{/if}
					<span class="fh-pagination__info">{l s='Page' mod='fhblog'} {$fh_blog_page|intval} {l s='of' mod='fhblog'} {$fh_blog_page_count|intval}</span>
					{if $fh_blog_page < $fh_blog_page_count}
						<a class="fh-btn fh-btn--ghost" href="{$fh_blog_url|escape:'html':'UTF-8'}&id_blog_category={$fh_blog_selected_category|intval}&page={$fh_blog_page+1|intval}">{l s='Next' mod='fhblog'}</a>
					{/if}
				</div>
			{/if}
		{else}
			<p class="fh-empty-state">{l s='No stories yet in this category. Check back soon.' mod='fhblog'}</p>
		{/if}
	</div>
</div>
{/block}