{*
 * Farmhouse override of qlohotelreview room-type-name-after.tpl
 * Premium rating row under the room name — sprite stars + honest empty state.
 *}
{block name='fh_rating_row'}
	<div class="fh-rating-row">
		{if isset($num_reviews) && $num_reviews > 0}
			<span class="fh-rating-row__stars fh-stars" style="--fh-score:{($avg_rating / 5 * 100)|intval}">
				<span class="fh-stars__row">
					{section name=star loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
				</span>
				<span class="fh-stars__row fh-stars__row--fill">
					{section name=star2 loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
				</span>
			</span>
			<span class="fh-rating-row__score">{$avg_rating|string_format:'%.1f'}</span>
			<span class="fh-rating-row__max">/5</span>
			<span class="fh-rating-row__count">
				{$num_reviews}
				{if $num_reviews > 1}{l s='guest reviews' mod='qlohotelreview'}{else}{l s='guest review' mod='qlohotelreview'}{/if}
			</span>
		{else}
			<span class="fh-rating-row__stars fh-stars fh-stars--empty">
				<span class="fh-stars__row">
					{section name=star loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
				</span>
			</span>
			<span class="fh-rating-row__empty">
				{l s='No guest reviews yet' mod='qlohotelreview'} — <a href="#hotel-reviews">{l s='Be the first to review' mod='qlohotelreview'}</a>
			</span>
		{/if}
	</div>
{/block}
