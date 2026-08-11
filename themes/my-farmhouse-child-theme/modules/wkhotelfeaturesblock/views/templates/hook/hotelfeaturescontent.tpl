{*
* Farmhouse theme override for wkhotelfeaturesblock hotelfeaturescontent.tpl
* Amenities as responsive card grid (image + description).
*}

{block name='hotel_features_block'}
    {if isset($hotelAmenities) && $hotelAmenities}
        <div id="hotelAmenitiesBlock" class="fh-section fh-home-block fh-home-block--tint">
            {if $HOTEL_AMENITIES_HEADING && $HOTEL_AMENITIES_DESCRIPTION}
                <div class="fh-container">
                    {block name='hotel_features_block_heading'}
                        <h2 class="fh-section-title">{$HOTEL_AMENITIES_HEADING|escape:'htmlall':'UTF-8'}</h2>
                    {/block}
                    {block name='hotel_features_block_description'}
                        <p class="fh-section-subtitle">{$HOTEL_AMENITIES_DESCRIPTION|escape:'htmlall':'UTF-8'}</p>
                    {/block}
                </div>
            {/if}
            {block name='hotel_features_images'}
                <div class="fh-container fh-amenity-grid">
                    {foreach from=$hotelAmenities item=amenity name=amenityBlock}
                        <div class="fh-card fh-amenity-card">
                            <div class="fh-card__media">
                                <img loading="lazy" src="{$link->getMediaLink("`$module_dir|escape:'htmlall':'UTF-8'`views/img/hotels_features_img/`$amenity.id_features_block|escape:'htmlall':'UTF-8'`.jpg")}" alt="{$amenity['feature_title']|escape:'htmlall':'UTF-8'}">
                            </div>
                            <div class="fh-card__body">
                                <h3 class="fh-card__title">{$amenity['feature_title']|escape:'htmlall':'UTF-8'}</h3>
                                <p class="fh-amenity-card__desc">{$amenity['feature_description']|escape:'htmlall':'UTF-8'}</p>
                            </div>
                        </div>
                    {/foreach}
                </div>
            {/block}
        </div>
    {/if}
{/block}
