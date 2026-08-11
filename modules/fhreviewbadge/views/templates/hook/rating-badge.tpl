{*
 * Farmhouse review badge — shown on room cards when the hotel has approved guest reviews.
 *}
{if isset($fh_rating) && $fh_rating && $fh_rating.count > 0}
	<span class="fh-rating-badge">
		<span class="fh-rating-badge__stars fh-stars" style="--fh-score:{$fh_rating_percent}">
			<span class="fh-stars__row">
				{section name=star loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
			</span>
			<span class="fh-stars__row fh-stars__row--fill">
				{section name=star2 loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
			</span>
		</span>
		<span class="fh-rating-badge__score">{$fh_rating.avg|string_format:'%.1f'}</span>
		<span class="fh-rating-badge__count">
			{$fh_rating.count}
			{if $fh_rating.count > 1}{l s='reviews' mod='fhreviewbadge'}{else}{l s='review' mod='fhreviewbadge'}{/if}
		</span>
	</span>
{/if}
