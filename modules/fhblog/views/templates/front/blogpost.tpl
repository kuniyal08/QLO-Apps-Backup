{*
* Farmhouse: single story detail.
* Informational editorial content - never bookable.
*}

{block name='fh_blog_post'}
<div class="fh-blog-post fh-section">
	<div class="fh-container">
		<nav class="fh-breadcrumb" aria-label="Breadcrumb">
			<a href="{$fh_blog_list_url|escape:'html':'UTF-8'}">{l s='Stories' mod='fhblog'}</a>
			<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-chevron-right"/></svg>
			{if $fh_blog_category}
				<a href="{$fh_blog_list_url|escape:'html':'UTF-8'}&id_blog_category={$fh_blog_category->id|intval}">{$fh_blog_category->name|escape:'html':'UTF-8'}</a>
				<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-chevron-right"/></svg>
			{/if}
			<span>{$fh_blog_post->title|escape:'html':'UTF-8'}</span>
		</nav>

		<article class="fh-blog-post__article">
			<header class="fh-blog-post__head">
				{if $fh_blog_category}
					<span class="fh-tag">{$fh_blog_category->name|escape:'html':'UTF-8'}</span>
				{/if}
				<h1 class="fh-blog-post__title">{$fh_blog_post->title|escape:'html':'UTF-8'}</h1>
				<p class="fh-blog-post__meta">
					<span>{dateFormat date=$fh_blog_post->date_add full=0}</span>
					{if $fh_blog_post->author}<span class="fh-blog-post__author">{$fh_blog_post->author|escape:'html':'UTF-8'}</span>{/if}
				</p>
			</header>

			{if $fh_blog_post->cover}
				<div class="fh-blog-post__media">
					<img src="{$smarty.const._PS_IMG_}fhblog/{$fh_blog_post->cover|escape:'html':'UTF-8'}" alt="{$fh_blog_post->title|escape:'html':'UTF-8'}" width="1200" height="675">
				</div>
			{/if}

			<div class="fh-blog-post__content fh-prose">{$fh_blog_post->content}</div>
		</article>

		{if isset($fh_blog_related) && $fh_blog_related|@count}
			<section class="fh-blog-related fh-section">
				<header class="fh-section-head">
					<h2 class="fh-section-head__title">{l s='Keep reading' mod='fhblog'}</h2>
				</header>
				<div class="fh-blog-grid">
					{foreach $fh_blog_related as $post}
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
									<h3 class="fh-blog-card__title">{$post.title|escape:'html':'UTF-8'}</h3>
									<span class="fh-blog-card__read">{l s='Read story' mod='fhblog'}<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg></span>
								</div>
							</a>
						</article>
					{/foreach}
				</div>
			</section>
		{/if}

		{if isset($fh_blog_adjacent) && ($fh_blog_adjacent.prev || $fh_blog_adjacent.next)}
			<section class="fh-blog-adjacent fh-section-sm">
				<div class="fh-blog-adjacent__row">
					{if $fh_blog_adjacent.prev}
						<a class="fh-adjacent-link" href="{$fh_blog_post_url|escape:'html':'UTF-8'}&id_blog_post={$fh_blog_adjacent.prev.id_blog_post|intval}">
							<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-left"/></svg>
							<span>
								<small>{l s='Previous story' mod='fhblog'}</small>
								{$fh_blog_adjacent.prev.title|escape:'html':'UTF-8'}
							</span>
						</a>
					{/if}
					{if $fh_blog_adjacent.next}
						<a class="fh-adjacent-link fh-adjacent-link--next" href="{$fh_blog_post_url|escape:'html':'UTF-8'}&id_blog_post={$fh_blog_adjacent.next.id_blog_post|intval}">
							<span>
								<small>{l s='Next story' mod='fhblog'}</small>
								{$fh_blog_adjacent.next.title|escape:'html':'UTF-8'}
							</span>
							<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg>
						</a>
					{/if}
				</div>
			</section>
		{/if}
	</div>
</div>
{/block}