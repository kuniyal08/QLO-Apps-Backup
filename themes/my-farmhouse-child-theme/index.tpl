{*
* 2007-2017 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2017 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

{block name='fh_home_hero'}
	{assign var=header_img value=Configuration::get('WK_HOTEL_HEADER_IMAGE')}
	{assign var=header_img_avif value=$header_img|regex_replace:'/\.[^.]*$/':'.avif'}
	{assign var=header_img_webp value=$header_img|regex_replace:'/\.[^.]*$/':'.webp'}
	<div class="fh-hero">
		<div class="fh-hero__media" aria-hidden="true">
			<picture>
				<source type="image/avif" srcset="{$link->getMediaLink("`$smarty.const._PS_IMG_`$header_img_avif")}">
				<source type="image/webp" srcset="{$link->getMediaLink("`$smarty.const._PS_IMG_`$header_img_webp")}">
				<img src="{$link->getMediaLink("`$smarty.const._PS_IMG_`$header_img")}" alt="" width="1200" height="784" fetchpriority="high">
			</picture>
		</div>
		<div class="fh-hero__content fh-container">
			{block name='fh_home_hero_copy'}
				{if Configuration::get('WK_TITLE_HEADER_BLOCK')}
					<span class="fh-hero__eyebrow">{l s='Rural stays & local stories'}</span>
					<h1 class="fh-hero__title">{Configuration::get('WK_TITLE_HEADER_BLOCK')|escape:'htmlall':'UTF-8'}</h1>
				{/if}
				{if Configuration::get('WK_CONTENT_HEADER_BLOCK')}
					<p class="fh-hero__subtitle">{Configuration::get('WK_CONTENT_HEADER_BLOCK')|escape:'htmlall':'UTF-8'}</p>
				{/if}
			{/block}
		</div>
	</div>
{/block}

{block name='fh_home_trust'}
	<div class="fh-trust">
		<div class="fh-container">
			<ul class="fh-trust__list">
				<li class="fh-trust__item">
					<svg class="fh-ic fh-ic--circle" aria-hidden="true"><use href="#fh-ic-home"/></svg>
					<span>{l s='Authentic rural stays'}</span>
				</li>
				<li class="fh-trust__item">
					<svg class="fh-ic fh-ic--circle" aria-hidden="true"><use href="#fh-ic-leaf"/></svg>
					<span>{l s='Farmhouses, stays & cultural homes'}</span>
				</li>
				<li class="fh-trust__item">
					<svg class="fh-ic fh-ic--circle" aria-hidden="true"><use href="#fh-ic-tag"/></svg>
					<span>{l s='Direct booking, no hidden fees'}</span>
				</li>
				<li class="fh-trust__item">
					<svg class="fh-ic fh-ic--circle" aria-hidden="true"><use href="#fh-ic-phone"/></svg>
					<span>{l s='Local support, 24x7'}</span>
				</li>
			</ul>
		</div>
	</div>
{/block}

{block name='displayHomeTabContent'}
	{if isset($HOOK_HOME_TAB_CONTENT) && $HOOK_HOME_TAB_CONTENT|trim}
		{block name='displayHomeTab'}
			{if isset($HOOK_HOME_TAB) && $HOOK_HOME_TAB|trim}
				<ul id="home-page-tabs" class="nav nav-tabs clearfix">
					{$HOOK_HOME_TAB}
				</ul>
			{/if}
		{/block}
		<div class="tab-content">{$HOOK_HOME_TAB_CONTENT}</div>
	{/if}
{/block}
{block name='displayHome'}
	{if isset($HOOK_HOME) && $HOOK_HOME|trim}
		<div class="clearfix">{$HOOK_HOME}</div>
	{/if}
{/block}
