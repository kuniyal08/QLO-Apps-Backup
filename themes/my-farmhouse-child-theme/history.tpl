{*
* Farmhouse: premium bookings history.
* Keeps the footab table contract (id=order-list, data-hide, sort-ignore)
* and the displayHistoryTableHeading/Row hooks; restyled via CSS.
*}

{block name='history'}
	{capture name=path}
		<a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">
			{l s='My account'}
		</a>
		<span class="navigation-pipe">{$navigationPipe}</span>
		<span class="navigation_page">{l s='Bookings'}</span>
	{/capture}
	<div class="fh-account">
		{block name='errors'}
			{include file="$tpl_dir./errors.tpl"}
		{/block}
		<p class="fh-eyebrow">{l s='Your stays'}</p>
		{block name='history_heading'}
			<h1 class="fh-account__title">{l s='Bookings'}</h1>
		{/block}
		<p class="fh-account__copy">{l s='Here are the orders you\'ve placed since your account was created.'}</p>

		{if $slowValidation}
			<div class="fh-alert fh-alert--warn">{l s='If you have just placed an order, it may take a few minutes for it to be validated. Please refresh this page if your order is missing.'}</div>
		{/if}
		<div class="block-center" id="block-history">
			{if $orders && count($orders)}
				{block name='bookings_list'}
					<div class="fh-card fh-table-wrap">
						<table id="order-list" class="table footab fh-table">
							<thead>
								<tr>
									<th class="first_item" data-sort-ignore="true">{l s='Order reference'}</th>
									<th class="item">{l s='Date'}</th>
									<th data-hide="phone" class="item">{l s='Total price'}</th>
									{if isset($adv_active)}
										<th data-hide="phone" class="item">{l s='Due Price'}</th>
									{/if}
									<th data-sort-ignore="true" data-hide="phone,tablet" class="item">{l s='Payment'}</th>
									<th class="item">{l s='Status'}</th>
									<th data-sort-ignore="true" data-hide="phone,tablet" class="item">{l s='Invoice'}</th>
									<th data-sort-ignore="true" data-hide="phone,tablet" class="last_item">&nbsp;</th>
									{block name='displayHistoryTableHeading'}
										{hook h='displayHistoryTableHeading'}
									{/block}
								</tr>
							</thead>
							<tbody>
								{foreach from=$orders item=order name=myLoop}
									<tr class="{if $smarty.foreach.myLoop.first}first_item{elseif $smarty.foreach.myLoop.last}last_item{else}item{/if} {if $smarty.foreach.myLoop.index % 2}alternate_item{/if}">
										{block name='booking_reference'}
											<td class="history_link bold">
												<a class="fh-table__ref" href="{$link->getPageLink('order-detail', true, NULL, "id_order={$order.id_order|intval}")|escape:'html':'UTF-8'}">
													{Order::getUniqReferenceOf($order.id_order)}
												</a>
											</td>
										{/block}
										{block name='booking_date'}
											<td data-value="{$order.date_add|regex_replace:"/[\-\:\ ]/":""}" class="history_date bold">
												{dateFormat date=$order.date_add full=0}
											</td>
										{/block}
										{block name='booking_total_price'}
											<td class="history_price" data-value="{$order.total_paid}">
												<span class="price">
													{displayPrice price=$order.total_paid currency=$order.id_currency no_utf8=false convert=false}
												</span>
											</td>
										{/block}
										{block name='booking_due_price'}
											{if isset($adv_active)}
												<td class="history_price" data-value="{$order.due_amount}">
													<span class="price">
														{displayPrice price=$order.due_amount currency=$order.id_currency no_utf8=false convert=false}
													</span>
												</td>
											{/if}
										{/block}
										{block name='booking_method'}
											<td class="history_method">{$order.payment|escape:'html':'UTF-8'}</td>
										{/block}
										{block name='booking_state'}
											<td {if isset($order.order_state)} data-value="{$order.id_order_state}"{/if} class="history_state">
												{if isset($order.order_state)}
													<span class="fh-badge"{if isset($order.order_state_color) && $order.order_state_color} style="background-color:{$order.order_state_color|escape:'html':'UTF-8'}; border-color:{$order.order_state_color|escape:'html':'UTF-8'};"{/if}>
														{if $order.current_state|in_array:$overbooking_order_states}
															{l s='Order Not Confirmed'}
														{else}
															{$order.order_state|escape:'html':'UTF-8'}
														{/if}
													</span>
												{/if}
											</td>
										{/block}
										{block name='booking_invoice'}
											<td class="history_invoice">
												{if (isset($order.invoice) && $order.invoice && isset($order.invoice_number) && $order.invoice_number) && isset($invoiceAllowed) && $invoiceAllowed == true}
													<a class="fh-btn fh-btn--ghost fh-btn--sm" href="{$link->getPageLink('pdf-invoice', true, NULL, "id_order={$order.id_order}")|escape:'html':'UTF-8'}" title="{l s='Invoice'}" target="_blank">
														{l s='PDF'}
													</a>
												{else}
													-
												{/if}
											</td>
										{/block}
										{block name='booking_detail'}
											<td class="history_detail">
												<a class="fh-btn fh-btn--ghost fh-btn--sm" href="{$link->getPageLink('order-detail', true, NULL, "id_order={$order.id_order|intval}")|escape:'html':'UTF-8'}">
													{l s='Details'}
												</a>
											</td>
										{/block}
										{block name='displayHistoryTableRow'}
											{hook h='displayHistoryTableRow' id_order=$order.id_order}
										{/block}
									</tr>
								{/foreach}
							</tbody>
						</table>
					</div>
				{/block}
				<div id="block-order-detail" class="unvisible">&nbsp;</div>
			{else}
				<div class="fh-alert fh-alert--warn">{l s='You have not placed any orders.'}</div>
			{/if}
		</div>
		{block name='history_footer_links'}
			<p class="fh-account__back">
				<a class="fh-btn fh-btn--ghost" href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">
					{l s='Back to My account'}
				</a>
			</p>
		{/block}
	</div>
{/block}
