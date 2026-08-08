{*
* Farmhouse theme override for wkabouthotelblock hotelInteriorBlock.tpl
* Static responsive image grid (no carousel); hooks preserved.
*}

{block name='hotel_interior_block'}
    {if isset($InteriorImg) && $InteriorImg}
        <div id="hotelInteriorBlock" class="fh-section fh-home-block">
            {if $HOTEL_INTERIOR_HEADING && $HOTEL_INTERIOR_DESCRIPTION}
                <div class="fh-container">
                    {block name='hotel_interior_block_heading'}
                        <h2 class="fh-section-title">{$HOTEL_INTERIOR_HEADING|escape:'htmlall':'UTF-8'}</h2>
                    {/block}
                    {block name='hotel_interior_block_description'}
                        <p class="fh-section-subtitle">{$HOTEL_INTERIOR_DESCRIPTION|escape:'htmlall':'UTF-8'}</p>
                    {/block}
                    {block name='displayInteriorExtraContent'}
                        {hook h="displayInteriorExtraContent"}
                    {/block}
                </div>
            {/if}
            {block name='hotel_interior_images'}
                <div class="fh-container fh-interior-grid">
                    {foreach from=$InteriorImg item=img_name name=intImg}
                        <div class="fh-interior-grid__item">
                            <a class="fh-interior-grid__link" href="{$link->getMediaLink("`$module_dir|escape:'htmlall':'UTF-8'`views/img/hotel_interior/`$img_name['name']|escape:'htmlall':'UTF-8'`.jpg")}" title="{$img_name['display_name']|escape:'htmlall':'UTF-8'}" data-fancybox-group="interiorGallery" rel="interiorGallery">
                                <img loading="lazy" src="{$link->getMediaLink("`$module_dir|escape:'htmlall':'UTF-8'`views/img/hotel_interior/`$img_name['name']|escape:'htmlall':'UTF-8'`.jpg")}" class="img-responsive" alt="{$img_name['display_name']|escape:'htmlall':'UTF-8'}">
                                <span class="fh-interior-grid__label">{$img_name['display_name']|escape:'htmlall':'UTF-8'}</span>
                            </a>
                        </div>
                    {/foreach}
                </div>
            {/block}
        </div>
    {/if}
{/block}
