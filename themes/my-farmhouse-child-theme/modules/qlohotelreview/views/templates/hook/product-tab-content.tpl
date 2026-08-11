{*
 * Farmhouse override of qlohotelreview product-tab-content.tpl
 * Keeps the module's review blocks; upgrades the empty state.
 *}
{block name='hotel_reviews'}
	<div id="hotel-reviews" class="tab-pane card fh-reviews-tab {if isset($language_is_rtl) && $language_is_rtl} rtl {/if}">
		{if is_array($reviews) && count($reviews)}
			{block name='review_summary'}
				{include file='./_partials/review-summary.tpl'}
			{/block}
			{block name='media_list'}
				{include file='./_partials/media-list.tpl'}
			{/block}
			{block name='list_actions'}
				{include file='./_partials/list-actions.tpl'}
			{/block}
			{block name='review_list'}
				{include file='./_partials/review-list.tpl'}
			{/block}
		{else}
			{block name='fh_reviews_empty'}
				<div class="fh-reviews-empty">
					<div class="fh-reviews-empty__mark" aria-hidden="true">
						<svg class="fh-ic fh-ic--lg"><use href="#fh-ic-quote"/></svg>
					</div>
					<h3 class="fh-reviews-empty__title">{l s='No guest reviews yet' mod='qlohotelreview'}</h3>
					<p class="fh-reviews-empty__text">
						{l s='We are just getting started. Stayed with us? Share your experience and help other travellers discover the stay.' mod='qlohotelreview'}
					</p>
					<p class="fh-reviews-empty__hint">
						{l s='Reviews appear here after your completed stay.' mod='qlohotelreview'}
					</p>
				</div>
			{/block}
		{/if}
	</div>
{/block}
