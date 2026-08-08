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
<!DOCTYPE HTML>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7"{if isset($language_code) && $language_code} lang="{$language_code|escape:'html':'UTF-8'}"{/if}><![endif]-->
<!--[if IE 7]><html class="no-js lt-ie9 lt-ie8 ie7"{if isset($language_code) && $language_code} lang="{$language_code|escape:'html':'UTF-8'}"{/if}><![endif]-->
<!--[if IE 8]><html class="no-js lt-ie9 ie8"{if isset($language_code) && $language_code} lang="{$language_code|escape:'html':'UTF-8'}"{/if}><![endif]-->
<!--[if gt IE 8]> <html class="no-js ie9"{if isset($language_code) && $language_code} lang="{$language_code|escape:'html':'UTF-8'}"{/if}><![endif]-->
<html{if isset($language_code) && $language_code} lang="{$language_code|escape:'html':'UTF-8'}"{/if} {if isset($language_is_rtl) && $language_is_rtl}dir="rtl"{/if}>
	<head>
		<meta charset="utf-8" />
		<title>{$meta_title|escape:'html':'UTF-8'}</title>
		{if isset($meta_description) AND $meta_description}
			<meta name="description" content="{$meta_description|escape:'html':'UTF-8'}" />
		{/if}
		{if isset($meta_keywords) AND $meta_keywords}
			<meta name="keywords" content="{$meta_keywords|escape:'html':'UTF-8'}" />
		{/if}
		<meta name="generator" content="QloApps" />
		<meta name="robots" content="{if isset($nobots)}no{/if}index,{if isset($nofollow) && $nofollow}no{/if}follow" />
		<meta name="viewport" content="width=device-width, minimum-scale=0.25, maximum-scale=1.6, initial-scale=1.0" />
		<meta name="mobile-web-app-capable" content="yes" />
		<link rel="icon" type="image/vnd.microsoft.icon" href="{$favicon_url}?{$img_update_time}" />
		<link rel="shortcut icon" type="image/x-icon" href="{$favicon_url}?{$img_update_time}" />
		{if isset($css_files)}
			{foreach from=$css_files key=css_uri item=media}
				{if $css_uri == 'lteIE9'}
					<!--[if lte IE 9]>
					{foreach from=$css_files[$css_uri] key=css_uriie9 item=mediaie9}
					<link rel="stylesheet" href="{$css_uriie9|escape:'html':'UTF-8'}" type="text/css" media="{$mediaie9|escape:'html':'UTF-8'}" />
					{/foreach}
					<![endif]-->
				{else}
					<link rel="stylesheet" href="{$css_uri|escape:'html':'UTF-8'}" type="text/css" media="{$media|escape:'html':'UTF-8'}" />
				{/if}
			{/foreach}
		{/if}
		{if isset($js_defer) && !$js_defer && isset($js_files) && isset($js_def)}
			{$js_def}
			{foreach from=$js_files item=js_uri}
			<script type="text/javascript" src="{$js_uri|escape:'html':'UTF-8'}"></script>
			{/foreach}
		{/if}
		{block name='displayHeader'}
			{$HOOK_HEADER}
		{/block}
		<!-- Farmhouse design layer — loaded AFTER stock QloApps css -->
		<link rel="preload" href="{$css_dir|escape:'html':'UTF-8'}../fonts/fraunces-latin-300-600.woff2" as="font" type="font/woff2" crossorigin="anonymous">
		<link rel="preload" href="{$css_dir|escape:'html':'UTF-8'}../fonts/manrope-latin-200-800.woff2" as="font" type="font/woff2" crossorigin="anonymous">
		<link rel="stylesheet" href="{$css_dir|escape:'html':'UTF-8'}design-system.css" type="text/css" media="all" />
		<link rel="stylesheet" href="{$css_dir|escape:'html':'UTF-8'}components.css" type="text/css" media="all" />
		{if $page_name == 'index'}
			<link rel="stylesheet" href="{$css_dir|escape:'html':'UTF-8'}home.css" type="text/css" media="all" />
		{elseif $page_name == 'category' || $page_name == 'our-properties' || $page_name == 'product'}
			<link rel="stylesheet" href="{$css_dir|escape:'html':'UTF-8'}product_list.css" type="text/css" media="all" />
		{/if}
		{if $page_name == 'product'}
			<link rel="stylesheet" href="{$css_dir|escape:'html':'UTF-8'}product.css" type="text/css" media="all" />
		{/if}
		{if $page_name == 'order-opc' || $page_name == 'order' || $page_name == 'cart'}
			<link rel="stylesheet" href="{$css_dir|escape:'html':'UTF-8'}order-opc.css" type="text/css" media="all" />
		{/if}
		{if $page_name == 'authentication' || $page_name == 'my-account' || $page_name == 'identity' || $page_name == 'addresses' || $page_name == 'address' || $page_name == 'order-confirmation' || $page_name == 'order-detail' || $page_name == 'history' || $page_name == 'guest-tracking'}
			<link rel="stylesheet" href="{$css_dir|escape:'html':'UTF-8'}account.css" type="text/css" media="all" />
		{/if}
		<script type="text/javascript" src="{$js_dir|escape:'html':'UTF-8'}theme.js" defer="defer"></script>

		<!--[if IE 8]>
		<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
		<script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
		<![endif]-->
	</head>
	<body{if isset($page_name)} id="{$page_name|escape:'html':'UTF-8'}"{/if} class="{if isset($page_name)}{$page_name|escape:'html':'UTF-8'}{/if}{if isset($body_classes) && $body_classes|@count} {' '|implode:$body_classes}{/if}{if $hide_left_column} hide-left-column{else} show-left-column{/if}{if $hide_right_column} hide-right-column{else} hide-right-column{/if}{if isset($content_only) && $content_only} content_only{/if} lang_{$lang_iso}">
	{* Farmhouse stroke icon sprite (inline, self-hosted, original paths — no external font) *}
	<svg class="fh-sprite" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" style="display:none">
		<symbol id="fh-ic-home" viewBox="0 0 24 24"><path d="M3 10.5 12 3l9 7.5"/><path d="M5 9.5V21h14V9.5"/><path d="M10 21v-6h4v6"/></symbol>
		<symbol id="fh-ic-leaf" viewBox="0 0 24 24"><path d="M4 20C4 11 11 4 20 4c0 9-7 16-16 16Z"/><path d="M4 20c4-6 8-10 13-12"/></symbol>
		<symbol id="fh-ic-tag" viewBox="0 0 24 24"><path d="M3 12V4h8l10 10-8 8L3 12Z"/><circle cx="12" cy="12" r="1.2"/></symbol>
		<symbol id="fh-ic-phone" viewBox="0 0 24 24"><path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3.1 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.1 4.2 2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .4 2 .7 2.9a2 2 0 0 1-.5 2.1L8.1 9.9a16 16 0 0 0 6 6l1.2-1.2a2 2 0 0 1 2.1-.5c.9.3 1.9.6 2.9.7a2 2 0 0 1 1.7 2Z"/></symbol>
		<symbol id="fh-ic-quote" viewBox="0 0 24 24"><path fill="currentColor" stroke="none" d="M9.5 6C6.5 6 4 8.6 4 11.7c0 3 2.2 5.3 5 5.3 1 0 1.8-.3 2.4-.8-.5 1.8-2 3-3.8 3.4V22c4-.5 7-3.8 7-8.3C14.6 8.3 12.3 6 9.5 6Zm9 0c-3 0-5.5 2.6-5.5 5.7 0 3 2.2 5.3 5 5.3 1 0 1.8-.3 2.4-.8-.5 1.8-2 3-3.8 3.4V22c4-.5 7-3.8 7-8.3C23.6 8.3 21.3 6 18.5 6Z"/></symbol>
		<symbol id="fh-ic-star" viewBox="0 0 24 24"><path d="M12 3l2.7 5.6 6.1.8-4.5 4.3 1.1 6-5.4-2.9-5.4 2.9 1.1-6L3.2 9.4l6.1-.8L12 3Z"/></symbol>
		<symbol id="fh-ic-search" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M21 21l-4.3-4.3"/></symbol>
		<symbol id="fh-ic-calendar" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18"/><path d="M8 3v4M16 3v4"/></symbol>
		<symbol id="fh-ic-users" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.9"/><path d="M16 3.1a4 4 0 0 1 0 7.8"/></symbol>
		<symbol id="fh-ic-bed" viewBox="0 0 24 24"><path d="M2 4v16"/><path d="M2 8h18a2 2 0 0 1 2 2v10"/><path d="M2 17h20"/><path d="M6 8v9"/></symbol>
		<symbol id="fh-ic-shield" viewBox="0 0 24 24"><path d="M12 22s8-3.5 8-10V5l-8-3-8 3v7c0 6.5 8 10 8 10Z"/><path d="M8.5 11.5l2.5 2.5 4.5-4.5"/></symbol>
		<symbol id="fh-ic-pin" viewBox="0 0 24 24"><path d="M20 10c0 6-8 12-8 12S4 16 4 10a8 8 0 1 1 16 0Z"/><circle cx="12" cy="10" r="3"/></symbol>
		<symbol id="fh-ic-check" viewBox="0 0 24 24"><path d="M4 12.5l5 5L20 6.5"/></symbol>
		<symbol id="fh-ic-close" viewBox="0 0 24 24"><path d="M6 6l12 12M18 6L6 18"/></symbol>
		<symbol id="fh-ic-menu" viewBox="0 0 24 24"><path d="M4 7h16M4 12h16M4 17h16"/></symbol>
		<symbol id="fh-ic-chevron-down" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></symbol>
		<symbol id="fh-ic-chevron-right" viewBox="0 0 24 24"><path d="M9 6l6 6-6 6"/></symbol>
		<symbol id="fh-ic-chevron-left" viewBox="0 0 24 24"><path d="M15 6l-6 6 6 6"/></symbol>
		<symbol id="fh-ic-arrow-right" viewBox="0 0 24 24"><path d="M4 12h16M13 5l7 7-7 7"/></symbol>
		<symbol id="fh-ic-arrow-left" viewBox="0 0 24 24"><path d="M20 12H4M11 5l-7 7 7 7"/></symbol>
		<symbol id="fh-ic-plus" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></symbol>
		<symbol id="fh-ic-minus" viewBox="0 0 24 24"><path d="M5 12h14"/></symbol>
		<symbol id="fh-ic-trash" viewBox="0 0 24 24"><path d="M4 7h16"/><path d="M9 7V5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2"/><path d="M6 7l1 13h10l1-13"/><path d="M10 11v6M14 11v6"/></symbol>
		<symbol id="fh-ic-lock" viewBox="0 0 24 24"><rect x="4" y="11" width="16" height="9" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/><circle cx="12" cy="15.5" r="1"/></symbol>
		<symbol id="fh-ic-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3.6-6 8-6s8 2 8 6"/></symbol>
		<symbol id="fh-ic-info" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 11v6"/><path d="M12 7.5v.01"/></symbol>
		<symbol id="fh-ic-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 3"/></symbol>
		<symbol id="fh-ic-download" viewBox="0 0 24 24"><path d="M12 3v12"/><path d="M7 10l5 5 5-5"/><path d="M4 21h16"/></symbol>
		<symbol id="fh-ic-print" viewBox="0 0 24 24"><path d="M6 9V3h12v6"/><path d="M4 9h16a2 2 0 0 1 2 2v6h-4v4H6v-4H2v-6a2 2 0 0 1 2-2Z"/><path d="M17 14h.01"/></symbol>
		<symbol id="fh-ic-eye" viewBox="0 0 24 24"><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></symbol>
		<symbol id="fh-ic-pencil" viewBox="0 0 24 24"><path d="M17 3l4 4L8 20l-5 1 1-5L17 3Z"/></symbol>
		<symbol id="fh-ic-refresh" viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-2.6-6.3"/><path d="M21 3v6h-6"/></symbol>
		<symbol id="fh-ic-wifi" viewBox="0 0 24 24"><path d="M2.5 8.5a15 15 0 0 1 19 0"/><path d="M5.5 12a10 10 0 0 1 13 0"/><path d="M8.5 15.5a5 5 0 0 1 7 0"/><circle cx="12" cy="18.5" r="1"/></symbol>
		<symbol id="fh-ic-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></symbol>
		<symbol id="fh-ic-rupee" viewBox="0 0 24 24"><text x="12" y="16.5" text-anchor="middle" font-size="15" font-weight="600" fill="currentColor" stroke="none">₹</text></symbol>
	</svg>
	{if !isset($content_only) || !$content_only}
		{if isset($restricted_country_mode) && $restricted_country_mode}
			<div id="restricted-country">
				<p>{l s='You cannot place a new order from your country.'}{if isset($geolocation_country) && $geolocation_country} <span class="bold">{$geolocation_country|escape:'html':'UTF-8'}</span>{/if}</p>
			</div>
		{/if}
		<div id="page">
			<div class="header-container">
				<div class="fh-header-sticky" id="fh-header">
					<header id="header">
						<div class="banner">
							<div class="container">
								<div class="row">
									{block name='displayBanner'}
										{hook h="displayBanner"}
									{/block}
								</div>
							</div>
						</div>
						{block name='header_nav'}
							<div id="nav-main" class="fh-utility">
								<div class="fh-container">
									{block name='displayNav'}
										<nav>{hook h="displayNav"}</nav>
									{/block}
								</div>
							</div>
						{/block}
						{block name='header_top'}
								<div class="header-top">
								<div class="fh-container fh-header__inner">
									{assign var='fh_logo_url' value=$logo_url}
									{if !file_exists("{$smarty.const._PS_ROOT_DIR_}/img/{Configuration::get('PS_LOGO')}") && file_exists("{$smarty.const._PS_ROOT_DIR_}/img/farmhouse-up-logo-1776420896.jpg")}
										{assign var='fh_logo_url' value="{$smarty.const._PS_IMG_}farmhouse-up-logo-1776420896.jpg"}
									{/if}
									<div id="header_logo" class="fh-header__logo">
										<a href="{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}" title="{$shop_name|escape:'html':'UTF-8'}">
											<img class="logo img-responsive" src="{$fh_logo_url}" alt="{$shop_name|escape:'html':'UTF-8'}"/>
										</a>
									</div>
									<div class="fh-header__menu">
										{if isset($WK_DISPLAY_PROPERTIES_LINK_IN_HEADER) && $WK_DISPLAY_PROPERTIES_LINK_IN_HEADER}
											<div class="header-top-item header-top-item--desktop">
												<a href="{$link->getPageLink('our-properties')}" class="header-top-link fh-link-our-properties">{l s='Our Properties'}</a>
											</div>
										{/if}
										<div class="header-top-menu">
											{block name='displayTop'}
												{if isset($HOOK_TOP)}{$HOOK_TOP}{/if}
											{/block}
										</div>
									</div>
								</div>
							</div>
						{/block}
						{block name='displaySearchHotelPanel'}
							{hook h='displaySearchHotelPanel'}
						{/block}
					</header>
				{block name='displayAfterHeaderHotelDesc'}
					{hook h='displayAfterHeaderHotelDesc'}
				{/block}
			</div>
			</div>
			{block name='displayAfterHookTop'}
				{hook h='displayAfterHookTop'}
			{/block}
			<div class="columns-container">
				<div id="columns" class="container">
					{if $show_breadcrump}
						{block name='breadcrumb'}
							{include file="$tpl_dir./breadcrumb.tpl"}
						{/block}
					{/if}
					<div id="slider_row" class="row">
						<div id="top_column" class="center_column col-xs-12 col-sm-12">{hook h="displayTopColumn"}</div>
					</div>
					<div class="row">
						{if isset($left_column_size) && !empty($left_column_size)}
						<div id="left_column" class="column col-xs-12 col-sm-{$left_column_size|intval}">{$HOOK_LEFT_COLUMN}</div>
						{/if}
						{if isset($left_column_size) && isset($right_column_size)}{assign var='cols' value=(12 - $left_column_size - $right_column_size)}{else}{assign var='cols' value=12}{/if}
						<div id="center_column" class="center_column col-xs-12 col-sm-{$cols|intval}">
	{/if}
