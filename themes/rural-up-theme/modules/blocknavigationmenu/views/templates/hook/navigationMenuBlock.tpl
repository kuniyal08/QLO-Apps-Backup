{*
* Rural UP theme override for blocknavigationmenu navigationMenuBlock.tpl
* Keeps the module JS contract (.nav_toggle, #menu_cont, .menu_cont_left/right,
* .close_navbar, .navigation-link, displayDefaultNavigationHook/displayExternalNavigationHook).
*}

{block name='navigation_menu'}
	<button type="button" class="nav_toggle" aria-label="{l s='Open menu' mod='blocknavigationmenu'}">
		<span class="icon-bar"></span>
		<span class="icon-bar"></span>
		<span class="icon-bar"></span>
	</button>

	<div id="menu_cont" class="menu_cont_right" role="dialog" aria-label="{l s='Menu' mod='blocknavigationmenu'}">
		<div class="ru-menu">
			<header class="ru-menu__head">
				<a class="ru-menu__brand" href="{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}">{l s='Rural UP' mod='blocknavigationmenu'}</a>
				<button type="button" class="close_navbar ru-menu__close" aria-label="{l s='Close menu' mod='blocknavigationmenu'}"><svg class="ru-svg-icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-close"></use></svg></button>
			</header>
			<nav class="ru-menu__nav">
				<p class="ru-eyebrow">{l s='Explore' mod='blocknavigationmenu'}</p>
				<ul class="ru-menu__list">
					{if isset($navigation_links) && $navigation_links}
						{foreach $navigation_links as $navigationLink}
							<li><a class="navigation-link" href="{$navigationLink['link']}">{$navigationLink['name']}</a></li>
						{/foreach}
					{/if}
					{block name='displayDefaultNavigationHook'}
						{hook h="displayDefaultNavigationHook"}
					{/block}
				</ul>
			</nav>
			<div class="ru-menu__extra">
				{block name='displayExternalNavigationHook'}
					{hook h="displayExternalNavigationHook"}
				{/block}
			</div>
			<footer class="ru-menu__foot">
				<a href="{$link->getPageLink('contact-form')}"><svg class="ru-svg-icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-phone"></use></svg>{l s='Need help?' mod='blocknavigationmenu'}</a>
				<p>{l s='Demo stays · representative imagery' mod='blocknavigationmenu'}</p>
			</footer>
		</div>
	</div>
{/block}
