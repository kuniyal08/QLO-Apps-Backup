{*
* Farmhouse: region detail.
* Informational discovery content - never bookable.
*}

{block name='fh_region_detail'}
<div class="fh-region-detail">
	<section class="fh-region-hero fh-section">
		<div class="fh-container">
			<nav class="fh-breadcrumb" aria-label="Breadcrumb">
				<a href="{$fh_region_list_url|escape:'html':'UTF-8'}">{l s='Regions' mod='fhregions'}</a>
				<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-chevron-right"/></svg>
				<span>{$fh_region->name|escape:'html':'UTF-8'}</span>
			</nav>
			<p class="fh-eyebrow">{l s='Region' mod='fhregions'}</p>
			<h1 class="fh-region-hero__title">{$fh_region->name|escape:'html':'UTF-8'}</h1>
			{if $fh_region->blurb}
				<p class="fh-region-hero__blurb">{$fh_region->blurb|escape:'html':'UTF-8'}</p>
			{/if}
		</div>
	</section>

	{if $fh_region->description}
		<section class="fh-region-description fh-section-sm">
			<div class="fh-container">
				<div class="fh-prose">{$fh_region->description}</div>
			</div>
		</section>
	{/if}

	<section class="fh-region-hotels fh-section">
		<div class="fh-container">
			<header class="fh-section-head">
				<h2 class="fh-section-head__title">{l s='Farmstays in %s' sprintf=[$fh_region->name|escape:'html':'UTF-8'] mod='fhregions'}</h2>
				<p class="fh-section-head__sub">{l s='Handpicked places to stay in this region.' mod='fhregions'}</p>
			</header>

			{if isset($fh_region_hotels) && $fh_region_hotels|@count}
				<div class="fh-region-hotels__grid">
					{foreach $fh_region_hotels as $hotel}
						<article class="fh-card fh-hotel-card">
							<div class="fh-card__media">
								<div class="fh-mono fh-mono--tint" aria-hidden="true">{$hotel.hotel_name|substr:0:1}</div>
							</div>
							<div class="fh-card__body">
								<h3 class="fh-hotel-card__name">{$hotel.hotel_name|escape:'html':'UTF-8'}</h3>
								{if isset($hotel.rating) && $hotel.rating > 0}
									<p class="fh-hotel-card__rating"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-star"/></svg>{$hotel.rating|intval}/5</p>
								{/if}
								<a class="fh-btn fh-btn--ghost fh-hotel-card__cta" href="{$fh_properties_url|escape:'html':'UTF-8'}">
									{l s='View stays' mod='fhregions'}<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg>
								</a>
							</div>
						</article>
					{/foreach}
				</div>
			{else}
				<p class="fh-empty-state">{l s='Farmstays in this region are being added. Check the full list of stays.' mod='fhregions'} <a class="fh-link" href="{$fh_properties_url|escape:'html':'UTF-8'}">{l s='Browse all stays' mod='fhregions'}</a></p>
			{/if}
		</div>
	</section>

	{if isset($fh_region_hotels) && $fh_region_hotels|@count && isset($fh_region_activities) && $fh_region_activities|@count}
		<section class="fh-bundle fh-section-sm">
			<div class="fh-container fh-bundle__panel">
				<div class="fh-bundle__copy">
					<p class="fh-eyebrow">{l s='Stay + do' mod='fhregions'}</p>
					<h2 class="fh-bundle__title">{l s='Plan a %s weekend' sprintf=[$fh_region->name|escape:'html':'UTF-8'] mod='fhregions'}</h2>
					<p class="fh-bundle__text">{l s='Pair your stay with the experiences on the farm - barn mornings, village walks and wetlands at dusk. Book the stay, then let your host plan the rest.' mod='fhregions'}</p>
				</div>
				<div class="fh-bundle__actions">
					<a class="fh-btn fh-btn--primary" href="{$fh_properties_url|escape:'html':'UTF-8'}">{l s='Browse farmstays' mod='fhregions'}<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg></a>
					{if $fh_activities_url}
						<a class="fh-btn fh-btn--ghost" href="{$fh_activities_url|escape:'html':'UTF-8'}">{l s='See experiences' mod='fhregions'}<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg></a>
					{/if}
				</div>
			</div>
		</section>
	{/if}

	<section class="fh-region-activities fh-section fh-section--tint">
		<div class="fh-container">
			<header class="fh-section-head">
				<h2 class="fh-section-head__title">{l s='Things to do in %s' sprintf=[$fh_region->name|escape:'html':'UTF-8'] mod='fhregions'}</h2>
				<p class="fh-section-head__sub">{l s='Local experiences offered by the farmstays of this region.' mod='fhregions'}</p>
			</header>

			{if isset($fh_region_activities) && $fh_region_activities|@count}
				<div class="fh-activity-grid">
					{foreach $fh_region_activities as $activity}
						<article class="fh-card fh-activity-card">
							<div class="fh-card__body">
								{if $activity.category}
									<p class="fh-tag">{$activity.category|escape:'html':'UTF-8'}</p>
								{/if}
								<h3 class="fh-activity-card__name">{$activity.name|escape:'html':'UTF-8'}</h3>
								<p class="fh-activity-card__desc">{$activity.short_description|escape:'html':'UTF-8'}</p>
								<ul class="fh-chip-row">
									{if $activity.typical_duration}
										<li class="fh-chip fh-chip--soft"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-clock"/></svg>{$activity.typical_duration|escape:'html':'UTF-8'}</li>
									{/if}
									{if $activity.hotel_name}
										<li class="fh-chip fh-chip--soft"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-home"/></svg>{$activity.hotel_name|escape:'html':'UTF-8'}</li>
									{/if}
								</ul>
							</div>
						</article>
					{/foreach}
				</div>
				{if $fh_activities_url}
					<p class="fh-section-foot"><a class="fh-btn fh-btn--ghost" href="{$fh_activities_url|escape:'html':'UTF-8'}">{l s='See all activities' mod='fhregions'}<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg></a></p>
				{/if}
			{else}
				<p class="fh-empty-state">{l s='Activities in this region are being listed. Check back soon.' mod='fhregions'}</p>
			{/if}
		</div>
	</section>

	{if isset($fh_region_adjacent) && ($fh_region_adjacent.prev || $fh_region_adjacent.next)}
		<section class="fh-region-adjacent fh-section-sm">
			<div class="fh-container fh-region-adjacent__row">
				{if $fh_region_adjacent.prev}
					<a class="fh-adjacent-link" href="{$fh_region_detail_url|escape:'html':'UTF-8'}&id_region={$fh_region_adjacent.prev.id_region|intval}">
						<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-left"/></svg>
						<span>
							<small>{l s='Previous region' mod='fhregions'}</small>
							{$fh_region_adjacent.prev.name|escape:'html':'UTF-8'}
						</span>
					</a>
				{/if}
				{if $fh_region_adjacent.next}
					<a class="fh-adjacent-link fh-adjacent-link--next" href="{$fh_region_detail_url|escape:'html':'UTF-8'}&id_region={$fh_region_adjacent.next.id_region|intval}">
						<span>
							<small>{l s='Next region' mod='fhregions'}</small>
							{$fh_region_adjacent.next.name|escape:'html':'UTF-8'}
						</span>
						<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg>
					</a>
				{/if}
			</div>
		</section>
	{/if}
</div>
{/block}