{*
* Farmhouse: premium payment marks row (displayFooterPaymentInfo).
* Image marks render only when configured.
*}
{block name='fh_footer_payment'}
<div class="fh-footer-col fh-footer-col--pay">
	<p class="fh-footer-col__head">{l s='Payments we accept' mod='wkfooterpaymentblock'}</p>
	<div class="fh-footer-paymarks">
		{if isset($allPaymentBlocks) && $allPaymentBlocks}
			{foreach $allPaymentBlocks as $paymentBlock}
				<img src="{$link->getMediaLink("`$module_dir`views/img/payment_img/`$paymentBlock['id_payment_block']`.jpg")}" alt="" loading="lazy">
			{/foreach}
		{else}
			<span class="fh-footer-paymarks__note">{l s='Secure payment at booking time' mod='wkfooterpaymentblock'}</span>
		{/if}
	</div>
	<p class="fh-footer-col__note"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-lock"/></svg>{l s='Your details are safe with us' mod='wkfooterpaymentblock'}</p>
</div>
{/block}
