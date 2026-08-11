{*
 * Farmhouse review rating strip — shown under the booking search panel.
 *}
{if isset($fh_rating) && $fh_rating}
	<div class="fh-rating-strip">
		<span class="fh-rating-strip__stars fh-stars" style="--fh-score:{$fh_rating_percent}">
			<span class="fh-stars__row">
				{section name=star loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
			</span>
			<span class="fh-stars__row fh-stars__row--fill">
				{section name=star2 loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
			</span>
		</span>
		{if $fh_rating.count > 0}
			<span class="fh-rating-strip__score">{$fh_rating.avg|string_format:'%.1f'}</span>
			<span class="fh-rating-strip__count">{l s='%s verified guest reviews' sprintf=$fh_rating.count mod='fhreviewbadge'}</span>
		{else}
			<span class="fh-rating-strip__empty">{l s='No guest reviews yet' mod='fhreviewbadge'} — <a href="#hotel-reviews">{l s='be the first to review' mod='fhreviewbadge'}</a></span>
		{/if}
	</div>
{/if}
