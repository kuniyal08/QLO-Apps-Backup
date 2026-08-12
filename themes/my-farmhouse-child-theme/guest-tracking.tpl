{*
* Farmhouse: premium guest tracking.
* Preserves the tracking form contract (guestTracking, order_reference,
* email, submitGuestTracking) and the guest-to-customer transform form.
*}

{block name='guest_tracking'}

	{capture name=path}{l s='Guest Tracking'}{/capture}
	<div class="fh-account">
		<p class="fh-eyebrow">{l s='Find your stay'}</p>
		{block name='guest_tracking_heading'}
			<h1 class="fh-account__title">{l s='Guest Tracking'}</h1>
		{/block}

		{if isset($order_collection)}
			{foreach $order_collection as $order}
				{assign var=order_state value=$order->getCurrentState()}
				{assign var=invoice value=$order->invoice}
				{assign var=order_history value=$order->order_history}
				{assign var=overbooking_order_states value=$order->overbooking_order_states}
				{assign var=carrier value=$order->carrier}
				{assign var=address_invoice value=$order->address_invoice}
				{assign var=address_delivery value=$order->address_delivery}
				{assign var=inv_adr_fields value=$order->inv_adr_fields}
				{assign var=dlv_adr_fields value=$order->dlv_adr_fields}
				{assign var=invoiceAddressFormatedValues value=$order->invoiceAddressFormatedValues}
				{assign var=deliveryAddressFormatedValues value=$order->deliveryAddressFormatedValues}
				{assign var=currency value=$order->currency}
				{assign var=discounts value=$order->discounts}
				{assign var=invoiceState value=$order->invoiceState}
				{assign var=deliveryState value=$order->deliveryState}
				{assign var=products value=$order->products}
				{assign var=customizedDatas value=$order->customizedDatas}
				{assign var=HOOK_ORDERDETAILDISPLAYED value=$order->hook_orderdetaildisplayed}
				{assign var=total_convenience_fee_ti value=$order->total_convenience_fee_ti}
				{assign var=total_convenience_fee_te value=$order->total_convenience_fee_te}
				{assign var=total_demands_price_ti value=$order->total_demands_price_ti}
				{assign var=total_demands_price_te value=$order->total_demands_price_te}
				{assign var=any_back_order value=$order->any_back_order}
				{assign var=shw_bo_msg value=$order->shw_bo_msg}
				{assign var=back_ord_msg value=$order->back_ord_msg}
				{assign var=order_has_invoice value=$order->order_has_invoice}
				{assign var=cart_htl_data value=$order->cart_htl_data}
				{assign var=hotel_service_products value=$order->hotel_service_products}
				{assign var=standalone_service_products value=$order->standalone_service_products}
				{assign var=customerGuestDetail value=$order->customerGuestDetail}
				{assign var=obj_hotel_branch_information value=$order->obj_hotel_branch_information}
				{assign var=hotel_address_info value=$order->hotel_address_info}
				{assign var=hotel_refund_rules value=$order->hotel_refund_rules}

				{if isset($order->total_old)}
					{assign var=total_old value=$order->total_old}
				{/if}
				{if isset($order->followup)}
					{assign var=followup value=$order->followup}
				{/if}

				<div id="block-history">
					<div id="block-order-detail" class="std">
						{block name='order_detail_wrapper'}
							{include file="./order-detail.tpl"}
						{/block}
					</div>
				</div>
			{/foreach}

			{block name='guest_transform'}
				{if isset($transformSuccess)}
					<div class="fh-alert fh-alert--success">{l s='Your guest account has been successfully transformed into a customer account. You can now log in as a registered user. '} <a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}">{l s='Log in now.'}</a></div>
				{else}
					<section class="fh-card fh-account__form-card transform-account">
						<p class="fh-auth__card-title">{l s='For More Advantages'}</p>
						<form method="post" action="{$action|escape:'html':'UTF-8'}#guestToCustomer" class="fh-form">
							{block name='errors'}
								{include file="$tpl_dir./errors.tpl"}
							{/block}
							<p class="fh-auth__card-copy">{l s='Transform your guest account into a customer account and enjoy:'}</p>
							<ul class="fh-list">
								<li>{l s='- Personalized and secure access.'}</li>
								<li>{l s='- Fast and easy checkout'}</li>
								<li>{l s='- Easier refund process'}</li>
							</ul>
							<div class="fh-field form-group password">
								<label class="fh-field__label">{l s='Set your password:'}</label>
								<input type="password" name="password" class="fh-field__input" />
							</div>

							<input type="hidden" name="id_order" value="{if isset($order->id)}{$order->id}{else}{if isset($smarty.get.id_order)}{$smarty.get.id_order|escape:'html':'UTF-8'}{else}{if isset($smarty.post.id_order)}{$smarty.post.id_order|escape:'html':'UTF-8'}{/if}{/if}{/if}" />
							<input type="hidden" name="order_reference" value="{if isset($smarty.get.order_reference)}{$smarty.get.order_reference|escape:'html':'UTF-8'}{else}{if isset($smarty.post.order_reference)}{$smarty.post.order_reference|escape:'html':'UTF-8'}{/if}{/if}" />
							<input type="hidden" name="email" value="{if isset($smarty.get.email)}{$smarty.get.email|escape:'html':'UTF-8'}{else}{if isset($smarty.post.email)}{$smarty.post.email|escape:'html':'UTF-8'}{/if}{/if}" />

							<div class="fh-form__actions">
								<button type="submit" name="submitTransformGuestToCustomer" class="fh-btn fh-btn--primary">
									{l s='Send'}
								</button>
							</div>
						</form>
					</section>
				{/if}
			{/block}
		{else}
			{block name='errors'}
				{include file="$tpl_dir./errors.tpl"}
			{/block}
			{if isset($show_login_link) && $show_login_link}
				<p class="fh-account__copy"><a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">{l s='Click here to log in to your customer account.'}</a></p>
			{/if}
			{if isset($smarty.get.ord_conf) && $smarty.get.ord_conf}
				<div class="fh-alert fh-alert--success">{l s='Your'} {if $total_rooms_booked > 1}{l s='bookings have'}{else}{l s='booking has'}{/if} {l s='been created successfully!'}</div>
			{/if}
			{block name='guest_tracking_form'}
				<section class="fh-card fh-account__form-card">
					<form method="post" action="{$action|escape:'html':'UTF-8'}" class="fh-form" id="guestTracking">
						<fieldset class="description_box">
							<h2 class="fh-auth__card-title">{l s='To track your order, please enter the following information:'}</h2>
							<div class="fh-field form-group">
								<label class="fh-field__label">{l s='Order Reference:'}</label>
								<input class="fh-field__input" type="text" name="order_reference" value="{if isset($smarty.get.id_order)}{$smarty.get.id_order|escape:'html':'UTF-8'}{else}{if isset($smarty.post.id_order)}{$smarty.post.id_order|escape:'html':'UTF-8'}{/if}{/if}" size="8" />
								<span class="fh-field__hint">{l s='For example: QIIXJXNUI'}</span>
							</div>
							<div class="fh-field form-group">
								<label class="fh-field__label">{l s='Email:'}</label>
								<input class="fh-field__input" type="email" name="email" value="{if isset($smarty.get.email)}{$smarty.get.email|escape:'html':'UTF-8'}{else}{if isset($smarty.post.email)}{$smarty.post.email|escape:'html':'UTF-8'}{/if}{/if}" />
							</div>
							{block name='guest_tracking_submit'}
								<div class="fh-form__actions">
									<button type="submit" name="submitGuestTracking" class="fh-btn fh-btn--primary">
										{l s='Send'}
									</button>
								</div>
							{/block}
						</fieldset>
					</form>
				</section>
			{/block}
		{/if}
	</div>
{/block}
