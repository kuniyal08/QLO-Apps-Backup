{*
* Farmhouse theme override for wkroomsearchblock categoryPageSearch.tpl
* Renders via displayAfterHookTop on category pages (sticky under header).
*}

{block name='category_page_search_panel'}
    {if isset($hotels_info) && count($hotels_info)}
        <div class="header-rmsearch-wrapper fh-search-panel fh-search-panel--sticky" data-fh-search-panel>
            <div class="fh-container fh-search-panel__inner">
                {block name='search_form'}
                    {include file="./searchForm.tpl"}
                {/block}
                {block name='displayFhRatingStrip'}
                    {hook h='displayFhHotelRating' id_hotel=$id_hotel}
                {/block}
            </div>
        </div>
    {/if}
{/block}
