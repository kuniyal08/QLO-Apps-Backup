{block name='hotel_features_block'}
{if isset($hotelAmenities) && $hotelAmenities}
<section id="hotelAmenitiesBlock" class="ru-section ru-section--sage">
    <div class="ru-container">
        <header class="ru-section-head"><div><p class="ru-eyebrow">{l s='Book with confidence' mod='wkhotelfeaturesblock'}</p><h2>{l s='The details that make a good stay easier' mod='wkhotelfeaturesblock'}</h2></div><p class="ru-section-intro">{l s='Simple booking, thoughtful places and support when you need it.' mod='wkhotelfeaturesblock'}</p></header>
        <div class="ru-benefits">
        {foreach from=$hotelAmenities item=amenity name=amenityBlock}
            <article class="ru-benefit">{if $smarty.foreach.amenityBlock.iteration == 1}<svg class="ru-benefit__icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-bed"></use></svg>{elseif $smarty.foreach.amenityBlock.iteration == 2}<svg class="ru-benefit__icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-food"></use></svg>{elseif $smarty.foreach.amenityBlock.iteration == 3}<svg class="ru-benefit__icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-compass"></use></svg>{else}<svg class="ru-benefit__icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-shield"></use></svg>{/if}<h3>{$amenity.feature_title|escape:'htmlall':'UTF-8'}</h3><p>{$amenity.feature_description|escape:'htmlall':'UTF-8'}</p></article>
        {/foreach}
        </div>
    </div>
</section>
{/if}
{/block}
