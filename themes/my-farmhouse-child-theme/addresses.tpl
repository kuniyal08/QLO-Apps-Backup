{*
* Farmhouse: premium addresses list — card grid with update/delete.
* Preserves the invoice-address picker, addressFormatedList output and the
* add/update/delete link contract (id_address GET param).
*}

{block name='addresses'}
	<div class="fh-account">
		{if isset($multipleAddresses) && $multipleAddresses}
			<p class="fh-eyebrow">{l s='Invoice address'}</p>
			<h1 class="fh-account__title">{l s='Addresses'}</h1>
			{include file="$tpl_dir./errors.tpl"}
			<p class="fh-account__copy">{l s='Please specify which address you prefer to use as your invoice address.'}</p>
			<section class="fh-card fh-account__form-card">
				<form action="{$link->getPageLink('address', true)|escape:'html':'UTF-8'}" method="post" class="fh-form">
					{foreach $multipleAddresses as $addressList}
						<div class="fh-check fh-check--radio">
							<input type="radio" name="id_address" id="{$addressList.id_address}" value="{$addressList.id_address}" class="address-radio"{if $addressList.id_address == $invoiceAddress} checked="checked"{/if} />
							<label for="{$addressList.id_address}">{$addressList.alias}</label>
						</div>
						<div class="fh-address-formatted">
							{$addressList.addressFormatedList nofilter}
						</div>
					{/foreach}
					<div class="fh-form__actions">
						<button type="submit" name="submitAddress" class="fh-btn fh-btn--primary">
							{l s='Update the address'}
						</button>
					</div>
					<input type="hidden" name="id_customer" value="{$customer->id}" />
				</form>
			</section>
		{/if}
		<p class="fh-eyebrow">{l s='Your details'}</p>
		{block name='addresses_header'}
			<h1 class="fh-account__title">{l s='My addresses'}</h1>
		{/block}
		{include file="$tpl_dir./errors.tpl"}
		<ul class="fh-address-grid">
			{foreach from=$addresses item=address}
				<li>
					<div class="fh-card fh-address-card" itemscope itemtype="http://schema.org/PostalAddress">
						<p class="fh-address-card__alias">{$address.alias|escape:'html':'UTF-8'}</p>
						<div class="fh-address-card__body">
							{$address.addressFormatedList nofilter}
						</div>
						<div class="fh-address-card__actions">
							<a href="{$link->getPageLink('address', true, NULL, 'id_address='|cat:$address.id_address)|escape:'html':'UTF-8'}" title="{l s='Update'}" class="fh-btn fh-btn--ghost fh-btn--sm">{l s='Update'}</a>
							<a href="{$link->getPageLink('address', true, NULL, 'id_address='|cat:$address.id_address)|escape:'html':'UTF-8'}" title="{l s='Delete'}" class="fh-btn fh-btn--ghost fh-btn--danger fh-btn--sm" data-confirm="{l s='Are you sure?'}" onclick="event.preventDefault(); if (confirm('{l s='Are you sure?'}')) location.href=this.href;">{l s='Delete'}</a>
						</div>
					</div>
				</li>
			{foreachelse}
				<li class="fh-account__empty">
					<div class="fh-alert fh-alert--warn">{l s='No addresses available.'}</div>
				</li>
			{/foreach}
		</ul>
		<p>
			<a href="{$link->getPageLink('address', true)|escape:'html':'UTF-8'}" title="{l s='Add an address'}" class="fh-btn fh-btn--primary">
				{l s='Add an address'}
			</a>
		</p>
	</div>
{/block}
{block name='addresses_footer'}
	{if isset($addresses_style) && isset($addresses_style|@count) && $addresses_style|@count}
		<style type="text/css">
			{$addresses_style nofilter}
		</style>
	{/if}
{/block}
