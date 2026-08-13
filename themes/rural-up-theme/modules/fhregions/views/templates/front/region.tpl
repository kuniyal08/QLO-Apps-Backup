{block name='fh_regions_listing'}
<main class="ru-discovery ru-regions">
    <div class="ru-container">
        <header class="ru-discovery-head">
            <p class="ru-eyebrow">{l s='Discover' mod='fhregions'}</p>
            <h1>{l s='Countrysides of Uttar Pradesh' mod='fhregions'}</h1>
            <p>{l s='Choose a landscape, then discover representative demo farmstays, local rhythms and stories from the land.' mod='fhregions'}</p>
        </header>
        {if isset($fh_regions) && $fh_regions|@count}
            <div class="ru-discovery-grid">
                {foreach $fh_regions as $region}
                    <article class="ru-discovery-card">
                        <a href="{$fh_region_detail_url|escape:'html':'UTF-8'}&id_region={$region.id_region|intval}" title="{$region.name|escape:'html':'UTF-8'}">
                            <div class="ru-discovery-card__media">
                                {if $region.cover}<img src="{$smarty.const._PS_IMG_}fhregions/{$region.cover|escape:'html':'UTF-8'}" alt="{$region.name|escape:'html':'UTF-8'}" loading="lazy">{else}<span class="ru-discovery-card__fallback" aria-hidden="true">{$region.name|substr:0:1}</span>{/if}
                            </div>
                            <div class="ru-discovery-card__body">
                                <p class="ru-eyebrow">{l s='Uttar Pradesh' mod='fhregions'}</p>
                                <h2>{$region.name|escape:'html':'UTF-8'}</h2>
                                <p>{$region.blurb|escape:'html':'UTF-8'}</p>
                                <span class="ru-discovery-card__meta">{$region.hotel_count|intval} {l s='farmstays' mod='fhregions'} · {$region.activity_count|intval} {l s='activities' mod='fhregions'}</span>
                                <span class="ru-link">{l s='Explore region' mod='fhregions'}</span>
                            </div>
                        </a>
                    </article>
                {/foreach}
            </div>
            {if $fh_regions_page_count > 1}
                <nav class="ru-discovery-pagination" aria-label="{l s='Region pages' mod='fhregions'}">
                    {if $fh_regions_page > 1}<a class="ru-link" href="{$fh_regions_url|escape:'html':'UTF-8'}&page={$fh_regions_page-1|intval}">{l s='Previous' mod='fhregions'}</a>{/if}
                    <span>{l s='Page' mod='fhregions'} {$fh_regions_page|intval} {l s='of' mod='fhregions'} {$fh_regions_page_count|intval}</span>
                    {if $fh_regions_page < $fh_regions_page_count}<a class="ru-link" href="{$fh_regions_url|escape:'html':'UTF-8'}&page={$fh_regions_page+1|intval}">{l s='Next' mod='fhregions'}</a>{/if}
                </nav>
            {/if}
        {else}
            <p class="ru-empty-state">{l s='Regions are being added. Please check back soon.' mod='fhregions'}</p>
        {/if}
    </div>
</main>
{/block}
