{*
* Farmhouse: homepage region preview strip (displayHome).
* Informational discovery content - never bookable.
*}

{block name='fh_home_activities'}
{if isset($fh_activities_home) && $fh_activities_home|@count && isset($fh_activities_home_url) && $fh_activities_home_url}
	<section class="fh-home-activities fh-section">
		<div class="fh-container">
			<header class="fh-section-head">
				<p class="fh-eyebrow">{l s='Things to do' mod='fhregions'}</p>
				<h2 class="fh-section-head__title">{l s='Make each day an adventure' mod='fhregions'}</h2>
				<p class="fh-section-head__sub">{l s='Local experiences shared by the farmstays themselves - food, crafts, farms and wetlands.' mod='fhregions'}</p>
			</header>

			<ul class="fh-chip-row fh-home-activities__chips">
				{foreach $fh_activities_home as $activity}
					<li>
						<a class="fh-chip fh-chip--ghost fh-activity-chip" href="{$fh_activities_home_url|escape:'html':'UTF-8'}" title="{$activity.name|escape:'html':'UTF-8'}">
							{if $activity.category}<em class="fh-activity-chip__category">{$activity.category|escape:'html':'UTF-8'}</em>{/if}
							<span>{$activity.name|escape:'html':'UTF-8'}</span>
						</a>
					</li>
				{/foreach}
			</ul>

			<p class="fh-section-foot">
				<a class="fh-btn fh-btn--ghost" href="{$fh_activities_home_url|escape:'html':'UTF-8'}">{l s='All activities' mod='fhregions'}<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg></a>
			</p>
		</div>
	</section>
{/if}
{/block}

{block name='fh_home_regions'}
{if isset($fh_regions_home) && $fh_regions_home|@count}
	<section class="fh-home-regions fh-section">
		<div class="fh-container">
			<header class="fh-section-head">
				<p class="fh-eyebrow">{l s='Explore' mod='fhregions'}</p>
				<h2 class="fh-section-head__title">{l s='Explore the countryside' mod='fhregions'}</h2>
				<p class="fh-section-head__sub">{l s='Six regions of Uttar Pradesh, each with its own farmstays and ways of life.' mod='fhregions'}</p>
			</header>

			<div class="fh-home-regions__grid">
				{foreach $fh_regions_home as $region}
					<a class="fh-card fh-region-tile" href="{$fh_region_detail_url|escape:'html':'UTF-8'}&id_region={$region.id_region|intval}" title="{$region.name|escape:'html':'UTF-8'}">
						<div class="fh-card__media">
							{if $region.cover}
								<img src="{$smarty.const._PS_IMG_}fhregions/{$region.cover|escape:'html':'UTF-8'}" alt="{$region.name|escape:'html':'UTF-8'}" width="640" height="400" loading="lazy">
							{else}
								<div class="fh-mono fh-mono--{$region.position|intval}" aria-hidden="true">{$region.name|substr:0:1}</div>
							{/if}
						</div>
						<div class="fh-card__body fh-region-tile__body">
							<h3 class="fh-region-tile__name">{$region.name|escape:'html':'UTF-8'}</h3>
							<p class="fh-region-tile__blurb">{$region.blurb|escape:'html':'UTF-8'}</p>
							<span class="fh-region-tile__meta">
								{if $region.hotel_count > 0}{$region.hotel_count|intval} {l s='farmstays' mod='fhregions'}{/if}
								{if $region.hotel_count > 0 && $region.activity_count > 0} &middot; {/if}
								{if $region.activity_count > 0}{$region.activity_count|intval} {l s='activities' mod='fhregions'}{/if}
							</span>
						</div>
					</a>
				{/foreach}
			</div>

			<p class="fh-section-foot">
				<a class="fh-btn fh-btn--ghost" href="{$fh_regions_home_url|escape:'html':'UTF-8'}">{l s='All regions' mod='fhregions'}<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg></a>
			</p>
		</div>
	</section>
{/if}
{/block}