{*
* Farmhouse theme override for wkroomsearchblock landingPageSearch.tpl
* Renders inside displayAfterHookTop on the home page (in-hero panel).
*}

{block name='landing_page_search_panel'}
    {if isset($is_index_page) && $is_index_page}
        <div class="header-rmsearch-container header-rmsearch-hide-xs hidden-xs">
            {if isset($hotels_info) && count($hotels_info)}
                <div class="header-rmsearch-wrapper" id="xs_room_search_form">
                    <div class="header-rmsearch-primary">
                        <div class="fancy_search_header_xs" style="display:none;">
                            <p>{l s='Search Rooms' mod='wkroomsearchblock'}</p>
                            <hr>
                        </div>
                        <div class="container">
                            <div class="header-rmsearch-inner-wrapper">
                                <div class="fh-search-panel fh-search-panel--hero" data-fh-search-panel>
                                    {block name='search_form'}
                                        {include file="./searchForm.tpl"}
                                    {/block}
                                    <p class="fh-search-trust">{l s='Free cancellation · Direct booking · No hidden fees' mod='wkroomsearchblock'}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            {/if}
        </div>
    {/if}
{/block}
