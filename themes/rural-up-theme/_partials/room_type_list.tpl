{block name='displayRoomTypeListBefore'}{hook h='displayRoomTypeListBefore'}{/block}
{if !empty($booking_data['rm_data']) && (isset($booking_data['stats']) && $booking_data['stats']['num_avail'] || !empty($display_all_room_types))}
    <div class="ru-availability-list">
    {foreach from=$booking_data['rm_data'] item=room_v}
        {if $room_v['data']['available']|count || !empty($display_all_room_types)}
            <article class="room_cont ru-availability-card" data-id-product="{$room_v['id_product']|escape:'htmlall':'UTF-8'}">
                <a class="ru-availability-card__media" href="{$room_v['product_link']|escape:'htmlall':'UTF-8'}">
                    <img src="{$room_v['image']|escape:'htmlall':'UTF-8'}" alt="{$room_v['name']|escape:'htmlall':'UTF-8'}" class="room-type-image">
                    {block name='displayRoomTypeListImageAfter'}{hook h='displayRoomTypeListImageAfter' product=$room_v}{/block}
                </a>
                <div class="room_info_cont ru-availability-card__details">
                    <div class="ru-availability-card__heading">
                        <div><p class="ru-eyebrow">{l s='Room option'}</p><h2><a href="{$room_v['product_link']|escape:'htmlall':'UTF-8'}">{$room_v['name']|escape:'htmlall':'UTF-8'}</a></h2></div>
                        {if !isset($restricted_country_mode) && !$PS_CATALOG_MODE && !$order_date_restrict}<p class="rm_left ru-availability-card__scarcity" {if !empty($display_all_room_types) || $room_v['room_left'] > $warning_num}style="display:none"{/if}>{l s='Only'} <span class="remain_rm_qty">{$room_v['room_left']|escape:'html':'UTF-8'}</span> {l s='left for your dates'}</p>{/if}
                    </div>
                    <p class="rm_desc ru-availability-card__description">{$room_v['description_short']|strip_tags|truncate:220:'...'|escape:'html':'UTF-8'} <a class="view_more" href="{$room_v['product_link']|escape:'htmlall':'UTF-8'}">{l s='View details'}</a></p>
                    <div class="room_features_cont ru-availability-card__facts">
                        <div class="ru-availability-card__amenities">{if !empty($room_v['feature'])}{foreach from=$room_v['feature'] item=feat_v}<img title="{$feat_v.name|escape:'htmlall':'UTF-8'}" src="{$link->getMediaLink("`$feat_img_dir`{$feat_v.value}")|escape:'htmlall':'UTF-8'}" class="rm_amen" alt="{$feat_v.name|escape:'htmlall':'UTF-8'}">{/foreach}{/if}</div>
                        <p class="capa_txt">{$room_v['max_guests']|escape:'html':'UTF-8'} {l s='guests'} <span class="capa_data">{$room_v['max_adults']|escape:'html':'UTF-8'} {l s='adults'}, {$room_v['max_children']|escape:'html':'UTF-8'} {l s='children'}</span></p>
                    </div>
                </div>
                <div class="room_type_list_actions ru-availability-card__action">
                    {if !isset($restricted_country_mode) && !$PS_CATALOG_MODE && !$order_date_restrict && (!isset($display_all_room_types) || !$display_all_room_types)}
                        <div class="ru-availability-card__price"><span>{l s='From'}</span><strong class="rm_price_val">{if $room_v['feature_price']}{displayPrice price=$room_v['feature_price']|floatVal}{else}{displayPrice price=$room_v['price_without_reduction']|floatVal}{/if}</strong><small class="rm_price_txt">{l s='per night'}</small></div>
                        <div class="booking_room_fields ru-availability-card__booking">
                            {if isset($occupancy_required_for_booking) && $occupancy_required_for_booking}<div class="booking_guest_occupancy_conatiner">{block name='occupancy_field'}{include file="./occupancy_field.tpl" room_type_info=$room_v total_available_rooms=$room_v['room_left']}{/block}</div>{else}<div class="ru-quantity"><label>{l s='Rooms'}</label>{block name='quantity_field'}{include file="./quantity_field.tpl" total_available_rooms=$room_v['room_left']}{/block}</div>{/if}
                            <a cat_rm_check_in="{$booking_date_from|escape:'htmlall':'UTF-8'}" cat_rm_check_out="{$booking_date_to|escape:'htmlall':'UTF-8'}" href="" rm_product_id="{$room_v['id_product']}" cat_rm_book_nm_days="{$num_days|escape:'htmlall':'UTF-8'}" data-id-product-attribute="0" data-id-product="{$room_v['id_product']|intval}" class="btn btn-default button button-medium ajax_add_to_cart_button"><span>{l s='Reserve room'}</span></a>
                        </div>
                    {else}<a class="ru-link" href="{$room_v['product_link']|escape:'htmlall':'UTF-8'}">{l s='View room'}</a>{/if}
                </div>
            </article>
        {/if}
    {/foreach}
    </div>
{else}<div class="noRoomsAvailAlert ru-empty-state"><h2>{l s='No rooms are available for these dates.'}</h2><p>{l s='Try adjusting your dates or search another stay.'}</p></div>{/if}
{block name='displayRoomTypeListAfter'}{hook h='displayRoomTypeListAfter'}{/block}
