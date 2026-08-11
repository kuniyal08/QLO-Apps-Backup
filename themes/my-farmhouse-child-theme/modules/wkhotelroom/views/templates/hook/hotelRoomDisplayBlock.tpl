{*
* Farmhouse theme override for wkhotelroom hotelRoomDisplayBlock.tpl
* Booking.com-style room cards grid; hooks preserved.
*}

{block name='hotel_room_block'}
    {if isset($hotelRoomDisplay) && $hotelRoomDisplay}
        <div id="hotelRoomsBlock" class="fh-section fh-home-block fh-home-block--tint">
            {if $HOTEL_ROOM_DISPLAY_HEADING && $HOTEL_ROOM_DISPLAY_DESCRIPTION}
                <div class="fh-container">
                    {block name='hotel_room_block_heading'}
                        <h2 class="fh-section-title">{$HOTEL_ROOM_DISPLAY_HEADING|escape:'htmlall':'UTF-8'}</h2>
                    {/block}
                    {block name='hotel_room_block_description'}
                        <p class="fh-section-subtitle">{$HOTEL_ROOM_DISPLAY_DESCRIPTION|escape:'htmlall':'UTF-8'}</p>
                    {/block}
                </div>
            {/if}
            {block name='hotel_room_block_content'}
                <div class="fh-container fh-room-grid">
                    {foreach from=$hotelRoomDisplay item=roomDisplay name=htlRoom}
                        <div class="fh-card fh-room-card">
                            {block name='hotel_room_block_room_type_image'}
                                <a class="fh-card__media" href="{$link->getProductLink($roomDisplay.id_product)|escape:'html':'UTF-8'}">
                                    <img loading="lazy" src="{$roomDisplay.image|escape:'htmlall':'UTF-8'}" alt="{$roomDisplay.name|escape:'htmlall':'UTF-8'}" class="img-responsive width-100">
                                    {block name='displayHotelRoomsBlockImageAfter'}
                                        {hook h='displayHotelRoomsBlockImageAfter' room_type=$roomDisplay}
                                    {/block}
                                </a>
                            {/block}
                            <div class="fh-card__body">
                                {block name='hotel_room_block_room_type_description'}
                                    <h3 class="fh-card__title">{$roomDisplay.name|escape:'htmlall':'UTF-8'}</h3>
                                    <p class="fh-card__meta">
                                        {if $roomDisplay.show_price && !isset($restricted_country_mode) && !$PS_CATALOG_MODE}
                                            <span class="fh-card__price">
                                                {if $roomDisplay.feature_price_diff >= 0}
                                                    <span class="wk_roomType_price {if $roomDisplay.feature_price_diff>0}room_type_old_price{/if}">{convertPrice price = $roomDisplay.price_without_reduction}</span>
                                                {/if}
                                                {if $roomDisplay.feature_price_diff}
                                                    <span class="wk_roomType_price fh-card__price-current">{convertPrice price = $roomDisplay.feature_price}</span>
                                                {/if}
                                                <span class="wk_roomType_price_type fh-card__price-unit">/&nbsp;{l s='Per Night' mod='wkhotelroom'}</span>
                                            </span>
                                        {/if}
                                    </p>
                                    <p class="fh-room-card__desc">{$roomDisplay.description|escape:'html':'UTF-8'}</p>
                                {/block}
                                {block name='hotel_room_block_action'}
                                    <a class="fh-btn fh-btn--primary fh-btn--block" href="{$link->getProductLink($roomDisplay.id_product)|escape:'html':'UTF-8'}">
                                        <span>{if !isset($restricted_country_mode) && !$PS_CATALOG_MODE}{l s='Book now' mod='wkhotelroom'}{else}{l s='View' mod='wkhotelroom'}{/if}</span>
                                    </a>
                                {/block}
                            </div>
                        </div>
                    {/foreach}
                </div>
            {/block}
        </div>
    {/if}
{/block}
