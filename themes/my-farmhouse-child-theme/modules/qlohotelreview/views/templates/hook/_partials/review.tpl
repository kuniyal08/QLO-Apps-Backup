{*
 * Farmhouse override of qlohotelreview review.tpl
 * Premium review card — avatar, verified-stay badge, sprite stars.
 * Keeps .btn-helpful / .btn-report-abuse / fancybox bindings intact.
 *}
{block name='fh_review'}
	<div class="fh-review-card">
		<div class="fh-review-card__head">
			<span class="fh-review-card__avatar" aria-hidden="true">{$review.customer_name|escape:'html':'UTF-8'|substr:0:1}</span>
			<div class="fh-review-card__meta">
				<span class="fh-review-card__name">{$review.customer_name|escape:'html':'UTF-8'}</span>
				<span class="fh-review-card__badge">
					<svg class="fh-ic fh-ic--sm" aria-hidden="true"><use href="#fh-ic-check"/></svg>
					{l s='Verified stay' mod='qlohotelreview'}
				</span>
			</div>
			<div class="fh-review-card__side">
				<span class="fh-review-card__stars fh-stars" style="--fh-score:{($review.rating / 5 * 100)|intval}">
					<span class="fh-stars__row">
						{section name=star loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
					</span>
					<span class="fh-stars__row fh-stars__row--fill">
						{section name=star2 loop=5}<svg class="fh-ic fh-ic--star-sm" aria-hidden="true"><use href="#fh-ic-star"/></svg>{/section}
					</span>
				</span>
				<span class="fh-review-card__date">{dateFormat date=$review.date_add full=0}</span>
			</div>
		</div>
		<p class="fh-review-card__subject">{$review.subject|escape:'html':'UTF-8'}</p>
		{if isset($review.images) && is_array($review.images) && count($review.images)}
			<div class="images-wrap fh-review-card__images">
				{foreach $review.images as $image}
					<div class="image-wrap">
						<a class="review-images-fancybox" rel="review-images-gallery-{$review.id_hotel_review}" href="{$image}">
							<img class="img img-responsive" src="{$image}">
						</a>
					</div>
				{/foreach}
			</div>
		{/if}
		<p class="fh-review-card__text">{$review.description|escape:'html':'UTF-8'}</p>
		<div class="fh-review-card__actions">
			{if $logged && !$review.response_helpful}
				<a href="#" class="fh-review-card__helpful btn-helpful" data-id-hotel-review="{$review.id_hotel_review}">
					<svg class="fh-ic fh-ic--sm" aria-hidden="true"><use href="#fh-ic-thumb-up"/></svg>
					<span>{l s='Was this helpful?' mod='qlohotelreview'}</span>
				</a>
			{/if}
			{if $review.total_useful > 0}
				<span class="fh-review-card__helpful-count">{$review.total_useful} {if $review.total_useful > 1}{l s='people found this helpful' mod='qlohotelreview'}{else}{l s='person found this helpful' mod='qlohotelreview'}{/if}</span>
			{/if}
			{if $logged && !$review.response_report}
				<a href="#" class="fh-review-card__report btn-report-abuse" data-id-hotel-review="{$review.id_hotel_review}">
					<span>{l s='Report' mod='qlohotelreview'}</span>
				</a>
			{/if}
		</div>
		{if isset($review.message) && $review.message}
			<div class="fh-review-card__reply">
				<p class="fh-review-card__reply-head">
					{$review.hotel_name|escape:'html':'UTF-8'} — {l s='has replied on' mod='qlohotelreview'} {$review.reply_date|date_format}
				</p>
				<p class="fh-review-card__reply-text">{$review.message|escape:'html':'UTF-8'}</p>
			</div>
		{/if}
	</div>
{/block}
