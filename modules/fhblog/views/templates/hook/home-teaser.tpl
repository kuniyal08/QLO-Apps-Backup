{*
* Farmhouse: homepage latest stories teaser (displayHome).
* Informational editorial content - never bookable.
*}

{block name='fh_home_blog'}
{if isset($fh_blog_home) && $fh_blog_home|@count}
	<section class="fh-home-blog fh-section fh-section--tint">
		<div class="fh-container">
			<header class="fh-section-head">
				<p class="fh-eyebrow">{l s='Stories' mod='fhblog'}</p>
				<h2 class="fh-section-head__title">{l s='Stories from the countryside' mod='fhblog'}</h2>
				<p class="fh-section-head__sub">{l s='Farmstay diaries, village guides and the policy behind rural stays.' mod='fhblog'}</p>
			</header>

			<div class="fh-blog-grid">
				{foreach $fh_blog_home as $post}
					<article class="fh-card fh-blog-card">
						<a class="fh-blog-card__link" href="{$fh_blog_home_url|escape:'html':'UTF-8'}&id_blog_post={$post.id_blog_post|intval}" title="{$post.title|escape:'html':'UTF-8'}">
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
								<p class="fh-blog-card__excerpt">{$post.excerpt|escape:'html':'UTF-8'}</p>
								<span class="fh-blog-card__read">{l s='Read story' mod='fhblog'}<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg></span>
							</div>
						</a>
					</article>
				{/foreach}
			</div>

			<p class="fh-section-foot">
				<a class="fh-btn fh-btn--ghost" href="{$fh_blog_home_url|escape:'html':'UTF-8'}">{l s='All stories' mod='fhblog'}<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg></a>
			</p>
		</div>
	</section>
{/if}
{/block}