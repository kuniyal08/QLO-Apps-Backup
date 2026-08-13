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
{if !isset($content_only) || !$content_only}
					</div><!-- #center_column -->
					{if isset($right_column_size) && !empty($right_column_size)}
						<div id="right_column" class="col-xs-12 col-sm-{$right_column_size|intval} column">{$HOOK_RIGHT_COLUMN}</div>
					{/if}
					</div><!-- .row -->
					{block name='displayColumnsBottom'}
						{hook h='displayColumnsBottom'}
					{/block}
				</div><!-- #columns -->
			</div><!-- .columns-container -->
			{block name='displayFooter'}
				{if isset($HOOK_FOOTER)}
					{block name='displayFooterBefore'}
						{hook h='displayFooterBefore'}
					{/block}
					<!-- Footer -->
					<div class="footer-container">
						<footer id="footer"  class="container">
							<div class="ru-footer-utility">
								<section class="ru-footer-brand"><a class="ru-footer-wordmark" href="{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}">Rural UP</a><p>{l s='Thoughtful stays and local stories from beyond the city.'}</p><a href="{$link->getPageLink('contact-form')}" class="ru-footer-support">{l s='Need booking help?'}</a></section>
								<section><h3>{l s='Explore'}</h3><ul><li><a href="{$link->getPageLink('our-properties')}">{l s='All stays'}</a></li><li><a href="{$link->getModuleLink('fhregions', 'region')}">{l s='Regions'}</a></li><li><a href="{$link->getModuleLink('ruralactivities', 'activities')}">{l s='Activities'}</a></li><li><a href="{$link->getModuleLink('fhblog', 'blog')}">{l s='Stories'}</a></li></ul></section>
								<section><h3>{l s='Plan and manage'}</h3><ul><li><a href="{$link->getPageLink('my-account')}">{l s='Your account'}</a></li><li><a href="{$link->getPageLink('history')}">{l s='Your trips'}</a></li><li><a href="{$link->getPageLink('guest-tracking')}">{l s='Find a booking'}</a></li><li><a href="{$link->getPageLink('contact-form')}">{l s='Contact support'}</a></li></ul></section>
								<section><h3>{l s='Book with confidence'}</h3><p>{l s='Clear stay details, secure checkout and local support when plans change.'}</p><div class="ru-footer-marks"><span>{l s='Secure checkout'}</span><span>{l s='Verified stays'}</span></div></section>
							</div>
							<div class="ru-footer-provider-hooks" aria-hidden="true">{$HOOK_FOOTER}</div>
							<div class="ru-footer-note"><span>{l s='Copyright'} &copy; {$smarty.now|date_format:'%Y'} {l s='Rural UP'}</span><span>{l s='Payments are processed through the options shown at checkout.'}</span></div>
						</footer>
						{block name='displayAfterDefautlFooterHook'}
							{hook h="displayAfterDefautlFooterHook"}
						{/block}
					</div><!-- #footer -->
				{/if}
			{/block}
		</div><!-- #page -->
{/if}
{block name='global'}
	{include file="$tpl_dir./global.tpl"}
{/block}
	<script type="text/javascript" src="{$js_dir}rural-up.js"></script>
	{if !isset($content_only) || !$content_only}
		<nav class="ru-bottom-nav" aria-label="{l s='Mobile navigation'}">
			<a class="ru-home" href="{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}"><svg class="ru-svg-icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-home"></use></svg>{l s='Home'}</a>
			<a class="ru-stays" href="{$link->getPageLink('our-properties')}"><svg class="ru-svg-icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-search"></use></svg>{l s='Stays'}</a>
			<a class="ru-trips" href="{$link->getPageLink('history')}"><svg class="ru-svg-icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-trip"></use></svg>{l s='Trips'}</a>
			<a class="ru-account" href="{$link->getPageLink('my-account')}"><svg class="ru-svg-icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-user"></use></svg>{l s='Account'}</a>
		</nav>
	{/if}
	</body>
</html>
