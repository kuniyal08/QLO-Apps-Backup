{block name='fh_home_regions'}
{if isset($fh_regions_home) && $fh_regions_home|@count}
<section class="ru-section ru-section--paper">
    <div class="ru-container">
        <header class="ru-section-head"><div><p class="ru-eyebrow">{l s='Go beyond the city' mod='fhregions'}</p><h2>{l s='Choose a countryside with its own rhythm' mod='fhregions'}</h2></div><a class="ru-link" href="{$fh_regions_home_url|escape:'html':'UTF-8'}">{l s='All regions' mod='fhregions'}</a></header>
        <div class="ru-region-grid">
        {foreach $fh_regions_home as $region name=regions}
            <a class="ru-region" href="{$fh_region_detail_url|escape:'html':'UTF-8'}&id_region={$region.id_region|intval}">
                {if $region.cover}<img loading="lazy" src="{$smarty.const._PS_IMG_}fhregions/{$region.cover|escape:'html':'UTF-8'}" alt="{$region.name|escape:'html':'UTF-8'}">{elseif $smarty.foreach.regions.iteration == 1}<img loading="lazy" src="{$img_dir}editorial/region-green-stay.jpg" alt="">{elseif $smarty.foreach.regions.iteration == 2}<img loading="lazy" src="{$img_dir}editorial/region-landscape.jpg" alt="">{elseif $smarty.foreach.regions.iteration == 3}<img loading="lazy" src="{$img_dir}editorial/region-hills.jpg" alt="">{else}<span class="ru-region__fallback" aria-hidden="true">{$region.name|substr:0:1}</span>{/if}
                <span class="ru-region__body"><h3>{$region.name|escape:'html':'UTF-8'}</h3><p>{if $region.blurb}{$region.blurb|escape:'html':'UTF-8'}{else}{l s='Farm stays, local food and open skies.' mod='fhregions'}{/if}</p></span>
            </a>
        {/foreach}
        </div>
    </div>
</section>
{/if}
{/block}
{block name='fh_home_activities'}
{if isset($fh_activities_home) && $fh_activities_home|@count && isset($fh_activities_home_url)}
<section class="ru-section ru-section--sage"><div class="ru-container"><header class="ru-section-head"><div><p class="ru-eyebrow">{l s='Make a day of it' mod='fhregions'}</p><h2>{l s='Small experiences, close to your stay' mod='fhregions'}</h2></div><a class="ru-link" href="{$fh_activities_home_url|escape:'html':'UTF-8'}">{l s='All activities' mod='fhregions'}</a></header><ul class="ru-activity-list">{foreach $fh_activities_home as $activity}<li><a class="ru-activity" href="{$fh_activities_home_url|escape:'html':'UTF-8'}">{if $activity.category}<em>{$activity.category|escape:'html':'UTF-8'} </em>{/if}{$activity.name|escape:'html':'UTF-8'}</a></li>{/foreach}</ul></div></section>
{/if}
{/block}
