{*
* Farmhouse: premium contact — info card + form card + hotel branches.
* Preserves the contact dropdown contract (contact_type_ul / id_contact),
* GDPR + displayContactFormFieldsAfter hooks, honeypot and all JS vars.
*}

{block name='contact_form'}
	<div class="fh-account fh-contact">
		{if isset($smarty.get.confirm)}
			<div class="fh-alert fh-alert--success">{l s='Your message has been successfully sent to our team.'}</div>
		{/if}
		{block name='errors'}
			{include file="$tpl_dir./errors.tpl"}
		{/block}
		<p class="fh-eyebrow">{l s='We\'d love to hear from you'}</p>
		<h1 class="fh-account__title">{l s='Contact Us'}</h1>
		<p class="fh-account__copy">{l s='Reach out to us for any inquiries or assistance. We\'re here to help make your experience with us exceptional.'}</p>

		<div class="fh-contact__grid">
			{if (isset($gblHtlAddress) && $gblHtlAddress) && (isset($gblHtlPhone) && $gblHtlPhone) && (isset($gblHtlEmail) && $gblHtlEmail)}
				{block name='contact_form_info'}
					<aside class="fh-card fh-contact__info">
						<p class="fh-auth__card-title">{l s='Main Branch'}</p>
						{if isset($gblHtlAddress) && $gblHtlAddress }
							<div class="fh-contact__row">
								<p class="fh-contact__label"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-pin"/></svg>{l s='Address'}</p>
								<p class="fh-contact__value">{$gblHtlAddress}</p>
							</div>
						{/if}
						{if isset($gblHtlPhone) && $gblHtlPhone}
							<div class="fh-contact__row">
								<p class="fh-contact__label"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-phone"/></svg>{l s='Phone'}</p>
								<p class="fh-contact__value"><a href="tel:{$gblHtlPhone}">{$gblHtlPhone}</a></p>
							</div>
						{/if}
						{if isset($gblHtlEmail) && $gblHtlEmail}
							<div class="fh-contact__row">
								<p class="fh-contact__label"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-mail"/></svg>{l s='Mail Us'}</p>
								<p class="fh-contact__value"><a href="mailto:{$gblHtlEmail}">{$gblHtlEmail}</a></p>
							</div>
						{/if}
						{if isset($gblHtlRegistrationNumber) && $gblHtlRegistrationNumber}
							<div class="fh-contact__row">
								<p class="fh-contact__label">{l s='Registration number'}</p>
								<p class="fh-contact__value">{$gblHtlRegistrationNumber}</p>
							</div>
						{/if}
						{if isset($gblHtlFax) && $gblHtlFax}
							<div class="fh-contact__row">
								<p class="fh-contact__label">{l s='Fax'}</p>
								<p class="fh-contact__value">{$gblHtlFax}</p>
							</div>
						{/if}
					</aside>
				{/block}
			{/if}
			{block name='contact_form_content'}
				<section class="fh-card fh-account__form-card">
					{if isset($customerThread.token)}
						<form action="{$link->getPageLink('contact', null, null, array('token' => $customerThread.token))}" method="post" class="fh-form" enctype="multipart/form-data">
					{else}
						<form action="{$link->getPageLink('contact')}" method="post" class="fh-form" enctype="multipart/form-data">
					{/if}
						{if isset($displayContactName) && $displayContactName}
							<div class="fh-field form-group">
								<label for="user_name" class="fh-field__label">
									{l s='Name'}{if isset($contactNameRequired) && $contactNameRequired}*{/if}
								</label>
								<input class="fh-field__input contact_input" type="text" id="user_name" name="user_name" value="{if isset($smarty.post.user_name)}{$smarty.post.user_name}{elseif isset($customerThread.user_name)}{$customerThread.user_name|escape:'html':'UTF-8'}{elseif isset($customerName)}{$customerName}{/if}" {if isset($customerThread.user_name)} readonly{/if}/>
							</div>
						{/if}
						<div class="fh-field form-group">
							<label for="email" class="fh-field__label">
								{l s='Email'}*
							</label>
							{if isset($customerThread.email)}
								<input class="fh-field__input contact_input" type="email" id="email" name="from" value="{$customerThread.email|escape:'html':'UTF-8'}" readonly="readonly" />
							{else}
								<input class="fh-field__input contact_input validate" type="email" id="email" name="from" data-validate="isEmail" value="{if isset($smarty.post.email)}{$smarty.post.email}{else}{$email|escape:'html':'UTF-8'}{/if}" />
							{/if}
						</div>
						{if isset($displayContactPhone) && $displayContactPhone}
							<div class="fh-field form-group">
								<label for="phone" class="fh-field__label">
									{l s='Phone'}{if isset($contactPhoneRequired) && $contactPhoneRequired}*{/if}
								</label>
								<input class="fh-field__input contact_input" type="text" id="phone" name="phone" value="{if isset($smarty.post.phone)}{$smarty.post.phone}{else if isset($customerThread.phone)}{$customerThread.phone|escape:'html':'UTF-8'}{elseif isset($customerPhone)}{$customerPhone}{/if}" {if isset($customerThread.phone)}readonly="readonly"{/if}/>
							</div>
						{/if}
						<div class="fh-field form-group">
							<label for="subject" class="fh-field__label">
								{l s='Title'}*
							</label>
							<input class="fh-field__input contact_input" type="text" id="subject" name="subject" value="{if isset($smarty.post.subject)}{$smarty.post.subject}{else if isset($customerThread.subject)}{$customerThread.subject|escape:'html':'UTF-8'}{/if}" {if isset($customerThread.subject)}readonly="readonly"{/if}/>
						</div>
						{if !isset($customerThread.id_contact) && isset($allowContactSelection) && $allowContactSelection}
							<div class="fh-field form-group">
								<label for="message" class="fh-field__label">
									{l s='Send To'}*
								</label>
								<div class="dropdown">
									<button class="fh-field__input fh-contact__dropdown contact_type_input" type="button" data-toggle="dropdown">
										<span id="contact_type" class="fh-contact__dropdown-label">{l s='Choose'}</span>
										<input type="hidden" id="id_contact" name="id_contact" value="0">
										<span class="fh-contact__dropdown-arrow" aria-hidden="true">
											<svg class="fh-ic"><use href="#fh-ic-chevron-down"/></svg>
										</span>
									</button>
									<ul class="dropdown-menu contact_type_ul fh-contact__menu">
										{foreach from=$contacts item=contact}
											<li value="{$contact.id_contact|intval}"{if isset($smarty.request.id_contact) && $smarty.request.id_contact == $contact.id_contact} selected="selected"{/if}>{$contact.name|escape:'html':'UTF-8'}
											</li>
										{/foreach}
										{if isset($all_hotels_info) && $all_hotels_info}
											{foreach from=$all_hotels_info key=htl_k item=htl_v}
											{/foreach}
										{/if}
									</ul>
								</div>
							</div>
						{elseif isset($customerThread.id_contact) && isset($allowContactSelection) && $allowContactSelection}
							<input type="hidden" id="id_contact" name="id_contact" value="{$customerThread.id_contact|escape:'html':'UTF-8'}"/>
						{/if}
						<div class="fh-field form-group">
							<label for="message" class="fh-field__label">
								{l s='Message/Query'}*
							</label>
							<textarea class="fh-field__input contact_textarea" id="message" name="message">{if isset($message)}{$message|escape:'html':'UTF-8'|stripslashes}{/if}</textarea>
						</div>
						{if $fileupload == 1}
							<div class="fh-field form-group">
								<label for="fileUpload" class="fh-field__label">
									{l s='Attach File'}
								</label>
								<input type="hidden" name="MAX_FILE_SIZE" value="{if isset($max_upload_size) && $max_upload_size}{$max_upload_size|intval}{else}2000000{/if}" />
								<input type="file" name="fileUpload" id="fileUpload" class="fh-field__input" />
							</div>
						{/if}
						<p class="fh-field__hint">{l s='* Required fields'}</p>
						{hook h='displayGDPRConsent' moduleName='contactform'}
						{hook h='displayContactFormFieldsAfter'}
						<div class="fh-form__actions">
							<input type="text" name="url" value="" class="hidden" />
							<input type="hidden" name="contactKey" value="{$contactKey}" />
							<button class="fh-btn fh-btn--primary" type="submit" name="submitMessage" id="submitMessage">{l s='Send Message'}</button>
						</div>
					</form>
				</section>
			{/block}
		</div>

		{block name='displayBeforeHotelBranchInformation'}
			{hook h='displayBeforeHotelBranchInformation'}
		{/block}
		{block name='contact_form_hotel_branches'}
			{if isset($displayHotels) && $displayHotels && isset($hotelsInfo) && $hotelsInfo}
				<div class="fh-contact__hotels">
					<p class="fh-eyebrow">{l s='Our Hotels'}</p>
					<div class="fh-address-grid">
						{foreach $hotelsInfo as $hotel}
							<div class="fh-card fh-contact__hotel">
								<p class="fh-contact__city"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-pin"/></svg>{$hotel['city']}</p>
								<div class="fh-contact__hotel-main">
									<img class="fh-contact__hotel-img" src="{$hotel['image_url']}" alt="{$hotel['hotel_name']|escape:'html':'UTF-8'}">
									<div class="fh-contact__hotel-body">
										<p class="fh-address-card__alias">{$hotel['hotel_name']}</p>
										<p class="fh-contact__value">{$hotel['address']}, {$hotel['city']}, {if isset($hotel['state_name']) && $hotel['state_name']}{$hotel['state_name']},{/if} {$hotel['country_name']}, {$hotel['postcode']}</p>
										{if ($hotel['latitude'] != 0 || $hotel['longitude'] != 0) && $viewOnMap}
											<p>
												<a class="fh-btn fh-btn--ghost fh-btn--sm" href="http://maps.google.com/maps?daddr=({$hotel['latitude']},{$hotel['longitude']})" target="_blank">
													{l s='View on map'}
												</a>
											</p>
										{/if}
										<p class="fh-contact__value"><a href="tel:{$hotel['phone']}">{$hotel['phone']}</a></p>
										<p class="fh-contact__value"><a href="mailto:{$hotel['email']}">{$hotel['email']}</a></p>
									</div>
								</div>
							</div>
						{/foreach}
					</div>
				</div>
			{/if}
		{/block}
		{block name='displayAfterHotelBranchInformation'}
			{hook h='displayAfterHotelBranchInformation'}
		{/block}
		{block name='contact_form_hotel_locations'}
			{if isset($displayHotelMap) && $displayHotelMap && isset($hotelLocationArray)}
				<div id="googleMapWrapper">
					<div id="map"></div>
				</div>
			{/if}
		{/block}
	</div>

	{block name='contact_form_js_vars'}
		{strip}
			{addJsDefL name='contact_fileDefaultHtml'}{l s='No file selected' js=1}{/addJsDefL}
			{addJsDefL name='contact_fileButtonHtml'}{l s='Choose File' js=1}{/addJsDefL}
			{addJsDefL name='contact_map_get_dirs'}{l s='Get Directions' js=1}{/addJsDefL}
		{/strip}
		{if isset($hotelLocationArray)}
			{strip}
				{addJsDef hotelLocationArray = $hotelLocationArray}
			{/strip}
		{else}
			{strip}
				{addJsDef hotelLocationArray = 0}
			{/strip}
		{/if}
	{/block}
{/block}