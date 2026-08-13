{block name='hotel_room_block'}
{if isset($hotelRoomDisplay) && $hotelRoomDisplay}
<section id="hotelRoomsBlock" class="ru-section ru-section--paper">
    <div class="ru-container">
        <header class="ru-section-head"><div><p class="ru-eyebrow">{l s='Farmhouse collection' mod='wkhotelroom'}</p><h2>{l s='Scenic farmstays for unhurried weekends' mod='wkhotelroom'}</h2></div><a class="ru-link" href="{$link->getPageLink('our-properties')}">{l s='Browse all farmstays' mod='wkhotelroom'}</a></header>
        <div class="ru-stays-grid">
        {foreach from=$hotelRoomDisplay item=roomDisplay}
            {if !isset($seen[$roomDisplay.id_hotel])}
            {append var='seen' value=1 index=$roomDisplay.id_hotel}
            <article class="ru-stay-card">
                <a class="ru-stay-card__media" href="{if $roomDisplay.property_link}{$roomDisplay.property_link|escape:'html':'UTF-8'}{else}{$link->getProductLink($roomDisplay.id_product)|escape:'html':'UTF-8'}{/if}">
                    {if $roomDisplay.property_image}<img loading="lazy" src="{$roomDisplay.property_image|escape:'htmlall':'UTF-8'}" alt="{if $roomDisplay.hotel_name}{$roomDisplay.hotel_name|escape:'htmlall':'UTF-8'}{else}{$roomDisplay.name|escape:'htmlall':'UTF-8'}{/if}">{elseif $roomDisplay.image}<img loading="lazy" src="{$roomDisplay.image|escape:'htmlall':'UTF-8'}" alt="{$roomDisplay.name|escape:'htmlall':'UTF-8'}">{else}<span class="ru-stay-card__placeholder" aria-hidden="true">{$roomDisplay.name|substr:0:1}</span>{/if}
                    {block name='displayHotelRoomsBlockImageAfter'}{hook h='displayHotelRoomsBlockImageAfter' room_type=$roomDisplay}{/block}
                </a>
                <div class="ru-stay-card__body">
                    <p class="ru-stay-card__meta">{if $roomDisplay.property_location}{$roomDisplay.property_location|escape:'html':'UTF-8'}{/if}{if $roomDisplay.property_location && $roomDisplay.hotel_name} · {/if}{l s='Demo stay' mod='wkhotelroom'}</p>
                    <h3 class="ru-stay-card__name">{if $roomDisplay.hotel_name}{$roomDisplay.hotel_name|escape:'htmlall':'UTF-8'}{else}{$roomDisplay.name|escape:'htmlall':'UTF-8'}{/if}</h3>
                    <p class="ru-stay-card__desc">{if $roomDisplay.hotel_description}{$roomDisplay.hotel_description|strip_tags|truncate:108:'...'|escape:'html':'UTF-8'}{else}{$roomDisplay.description|strip_tags|truncate:108:'...'|escape:'html':'UTF-8'}{/if}</p>
                    <p class="ru-demo-disclosure">{l s='Representative imagery' mod='wkhotelroom'}</p>
                    <div class="ru-stay-card__foot"><span class="ru-price">{if $roomDisplay.show_price && !isset($restricted_country_mode) && !$PS_CATALOG_MODE}<strong>{if $roomDisplay.feature_price}{convertPrice price=$roomDisplay.feature_price}{else}{convertPrice price=$roomDisplay.price_without_reduction}{/if}</strong> / {l s='from' mod='wkhotelroom'}{/if}</span><a class="ru-link" href="{if $roomDisplay.property_link}{$roomDisplay.property_link|escape:'html':'UTF-8'}{else}{$link->getProductLink($roomDisplay.id_product)|escape:'html':'UTF-8'}{/if}">{l s='Explore farmhouse' mod='wkhotelroom'}</a></div>
                </div>
            </article>
            {/if}
        {/foreach}
        </div>
    </div>
</section>
{/if}
{/block}
