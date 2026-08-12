{*
* Farmhouse: premium My Account — card grid of account links.
* Keeps $linkLists loop + displayMyAccountBlockTop / displayCustomerAccount / displayCustomerAccountAfterTabs hooks.
*}

{block name='my_account_block'}
	<div class="fh-account">
		<p class="fh-eyebrow">{l s='Your space'}</p>
		<h1 class="fh-account__title">{l s='My account'}</h1>
		{include file="$tpl_dir./errors.tpl"}
		{block name='displayMyAccountBlockTop'}
			{hook h='displayMyAccountBlockTop'}
		{/block}
		{block name='account_lists'}
			<ul class="fh-account__grid">
				{foreach $linkLists as $linkList}
					<li>
						<a class="fh-card fh-account__tile" href="{$linkList.link}" title="{$linkList.title|escape:'html':'UTF-8'}">
							<span class="fh-account__tile-icon" aria-hidden="true"><i class="{$linkList.icon}"></i></span>
							<span class="fh-account__tile-title">{$linkList.title|escape:'html':'UTF-8'}</span>
							<svg class="fh-ic fh-account__tile-arrow" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg>
						</a>
					</li>
				{/foreach}
			</ul>
			{block name='displayCustomerAccount'}{hook h='displayCustomerAccount'}{/block}
			{block name='displayCustomerAccountAfterTabs'}{hook h='displayCustomerAccountAfterTabs'}{/block}
		{/block}
	</div>
{/block}
