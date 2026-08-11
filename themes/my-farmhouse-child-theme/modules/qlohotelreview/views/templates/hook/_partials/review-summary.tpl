{*
 * Farmhouse override of qlohotelreview review-summary.tpl
 * Premium summary — big score, sprite star overlay, category chips.
 *}
{block name='fh_review_summary'}
	<div class="fh-review-summary">
		<div class="fh-review-summary__head">
			<div class="fh-review-summary__score-block">
				<span class="fh-review-summary__score">{$summary.average|string_format:'%.1f'}</span>
				<span class="fh-review-summary__max">/5</span>
			</div>
			<div class="fh-review-summary__stars fh-stars" style="--fh-score:{($summary.average / 5 * 100)|intval}">
				<span class="fh-stars__row">
					{section name=star loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
				</span>
				<span class="fh-stars__row fh-stars__row--fill">
					{section name=star2 loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
				</span>
			</div>
			<p class="fh-review-summary__based">
				{l s='Based on %s verified guest reviews' sprintf=$summary.total_reviews mod='qlohotelreview'}
			</p>
		</div>
		{if is_array($summary.categories) && count($summary.categories)}
			<div class="fh-review-summary__cats">
				{foreach from=$summary.categories item=category}
					<span class="fh-review-summary__cat">
						<span class="fh-review-summary__cat-name">{$category.name}</span>
						<span class="fh-review-summary__cat-score">{$category.average|string_format:'%.1f'}</span>
					</span>
				{/foreach}
			</div>
		{/if}
	</div>
{/block}
