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
					<div class="footer-container">
						{block name='displayFooterBefore'}
							<div class="fh-footer-pre">
								{hook h='displayFooterBefore'}
							</div>
						{/block}
						<!-- Footer -->
						<footer id="footer">
							<div class="fh-container">
								<div class="row fh-footer-explore">
									<div class="col-xs-12">
										{block name='displayFooterExploreSectionHook'}
											{hook h='displayFooterExploreSectionHook'}
										{/block}
									</div>
								</div>
								<div class="row fh-footer-grid">
									<div class="fh-footer-grid__brand">
										{block name='displayFooterMostLeftBlock'}
											{hook h='displayFooterMostLeftBlock'}
										{/block}
									</div>
									<div class="fh-footer-grid__main fh-footer-hook">
										{block name='displayFooterAggregate'}
											{$HOOK_FOOTER}
										{/block}
									</div>
								</div>
								{block name='displayFooterNotificationHook'}
									<div class="row fh-footer-notification">
										<div class="col-xs-12">
											{hook h='displayFooterNotificationHook'}
										</div>
									</div>
								{/block}
								{block name='displayFooterPaymentInfo'}
									<div class="row fh-footer-payment">
										<div class="col-xs-12">
											{hook h='displayFooterPaymentInfo'}
										</div>
									</div>
								{/block}
								{block name='displayFooterAfter'}
									{hook h='displayFooterAfter'}
								{/block}
								{block name='displayFooterBottonHook'}
									{hook h='displayFooterBottonHook'}
								{/block}
							</div>
						</footer>
						{block name='displayAfterDefautlFooterHook'}
							{hook h="displayAfterDefautlFooterHook"}
						{/block}
					</div><!-- .footer-container -->
				{/if}
			{/block}
		</div><!-- #page -->
{/if}
{block name='global'}
	{include file="$tpl_dir./global.tpl"}
{/block}
	</body>
</html>
