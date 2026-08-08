{*
* Farmhouse theme override for wkroomsearchblock landingPageXsBtn.tpl
* Mobile "Search stays" pill that opens the search panel (fancybox contract kept).
*}

{block name='landing_page_search_button_mobile'}
	<div class="row fh-mobile-search-btn visible-xs">
		<div class="fh-container">
			<button id="xs_room_search" class="btn button button-medium fh-btn fh-btn--primary fh-btn--block" href="#xs_room_search_form"><span>{l s='Search stays' mod='wkroomsearchblock'}</span></button>
		</div>
	</div>
{/block}
