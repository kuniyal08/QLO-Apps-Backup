{*
* Farmhouse: regions directory listing.
* Informational discovery content - never bookable.
*}

{block name='fh_regions_listing'}
<div class="fh-regions fh-section">
	<div class="fh-container">
		<header class="fh-page-head">
			<p class="fh-eyebrow">{l s='Discover' mod='fhregions'}</p>
			<h1 class="fh-page-title">{l s='Regions of Uttar Pradesh' mod='fhregions'}</h1>
			<p class="fh-page-subtitle">{l s='Six countrysides, one river plain. Choose a region to find farmstays, local activities and the stories of the land.' mod='fhregions'}</p>
		</header>

		{if isset($fh_regions) && $fh_regions|@count}
			<div class="fh-region-grid">
				{foreach $fh_regions as $region}
					<article class="fh-card fh-region-card">
						<a class="fh-region-card__link" href="{$fh_region_detail_url|escape:'html':'UTF-8'}&id_region={$region.id_region|intval}" title="{$region.name|escape:'html':'UTF-8'}">
							<div class="fh-card__media fh-region-card__media">
								{if $region.cover}
									<img src="{$smarty.const._PS_IMG_}fhregions/{$region.cover|escape:'html':'UTF-8'}" alt="{$region.name|escape:'html':'UTF-8'}" width="800" height="450" loading="lazy">
								{else}
									<div class="fh-mono fh-mono--{$region.position|intval}" aria-hidden="true">{$region.name|substr:0:1}</div>
								{/if}
							</div>
							<div class="fh-card__body">
								<h2 class="fh-region-card__name">{$region.name|escape:'html':'UTF-8'}</h2>
								<p class="fh-region-card__blurb">{$region.blurb|escape:'html':'UTF-8'}</p>
								<ul class="fh-chip-row">
									{if isset($region.hotel_count) && $region.hotel_count > 0}
										<li class="fh-chip"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-home"/></svg>{$region.hotel_count|intval} {l s='farmstays' mod='fhregions'}</li>
									{/if}
									{if isset($region.activity_count) && $region.activity_count > 0}
										<li class="fh-chip"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-leaf"/></svg>{$region.activity_count|intval} {l s='activities' mod='fhregions'}</li>
									{/if}
									<li class="fh-chip fh-chip--ghost"><span>{l s='Explore region' mod='fhregions'}</span><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg></li>
								</ul>
							</div>
						</a>
					</article>
				{/foreach}
			</div>

			{if $fh_regions_page_count > 1}
				<div class="fh-pagination">
					{if $fh_regions_page > 1}
						<a class="fh-btn fh-btn--ghost" href="{$fh_regions_url|escape:'html':'UTF-8'}&page={$fh_regions_page-1|intval}">{l s='Previous' mod='fhregions'}</a>
					{/if}
					<span class="fh-pagination__info">{l s='Page' mod='fhregions'} {$fh_regions_page|intval} {l s='of' mod='fhregions'} {$fh_regions_page_count|intval}</span>
					{if $fh_regions_page < $fh_regions_page_count}
						<a class="fh-btn fh-btn--ghost" href="{$fh_regions_url|escape:'html':'UTF-8'}&page={$fh_regions_page+1|intval}">{l s='Next' mod='fhregions'}</a>
					{/if}
				</div>
			{/if}
		{else}
			<p class="fh-empty-state">{l s='Regions are being added. Please check back soon.' mod='fhregions'}</p>
		{/if}
	</div>
</div>
{/block}