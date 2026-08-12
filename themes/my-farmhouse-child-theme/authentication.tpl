{*
* Farmhouse: premium authentication — login / create account / guest checkout.
* All form ids, field names and hook slots preserved (QloApps contract).
*}

{block name='authentication'}
	{capture name=path}
		{if !isset($email_create)}{l s='Authentication'}{else}
			<a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Authentication'}">{l s='Authentication'}</a>
			<span class="navigation-pipe">{$navigationPipe}</span>{l s='Create your account'}
		{/if}
	{/capture}
	{if isset($back) && preg_match("/^http/", $back)}{assign var='current_step' value='login'}{block name='order_steps'}{include file="$tpl_dir./order-steps.tpl"}{/block}{/if}
	{block name='errors'}
		{include file="$tpl_dir./errors.tpl"}
	{/block}
	{block name='authentication_header'}
		<div class="fh-auth__head">
			<p class="fh-eyebrow">{l s='Welcome'}</p>
			<h1 class="fh-auth__title">{if !isset($email_create)}{l s='Sign in to plan your stay'}{else}{l s='Create your account'}{/if}</h1>
			<p class="fh-auth__sub">{l s='Book farmstays, save your trips and manage bookings in one place.'}</p>
		</div>
	{/block}
	{assign var='stateExist' value=false}
	{assign var="postCodeExist" value=false}
	{assign var="dniExist" value=false}
	{if !isset($email_create)}
		<div class="fh-auth">
			{if isset($smarty.get.guest_transform_success) && $smarty.get.guest_transform_success}
				<div class="fh-alert fh-alert--success">
					{l s='Your guest account has been transformed into a customer account successfully and the login credentials have been sent to you. Please make sure to change the password for security.'}
				</div>
			{/if}
			<div class="fh-auth__grid">
				<section class="fh-card fh-auth__card">
					{block name='authentication_create_account_form'}
						<form action="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" method="post" id="create-account_form" class="fh-form">
							<h3 class="fh-auth__card-title">{l s='New to Farmhouse stays?'}</h3>
							<p class="fh-auth__card-copy">{l s='Enter your email and we will set up your account.'}</p>
							<div class="fh-alert fh-alert--info" id="create_account_information" style="display:none"></div>
							<div class="fh-alert fh-alert--error" id="create_account_error" style="display:none"></div>
							<div class="fh-field">
								<label for="email_create" class="fh-field__label">{l s='Email address'}</label>
								<input type="email" class="is_required validate fh-field__input" data-validate="isEmail" id="email_create" name="email_create" value="{if isset($smarty.post.email_create)}{$smarty.post.email_create|stripslashes}{/if}" placeholder="{l s='you@example.com'}" />
							</div>
							{block name='authentication_create_account_submit'}
								<div class="fh-form__actions">
									{if isset($back)}<input type="hidden" class="hidden" name="back" value="{$back|escape:'html':'UTF-8'}" />{/if}
									<button class="fh-btn fh-btn--primary" type="submit" id="SubmitCreate" name="SubmitCreate">
										{l s='Create an account'}
										<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg>
									</button>
								</div>
							{/block}
						</form>
					{/block}
				</section>
				<section class="fh-card fh-auth__card">
					{block name='authentication_login_form'}
						<form action="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" method="post" id="login_form" class="fh-form">
							<h3 class="fh-auth__card-title">{l s='Welcome back'}</h3>
							<p class="fh-auth__card-copy">{l s='Sign in to see your bookings and continue planning.'}</p>
							<div class="fh-field">
								<label class="fh-field__label" for="email">{l s='Email address'}</label>
								<input class="is_required validate fh-field__input" data-validate="isEmail" type="email" id="email" name="email" value="{if isset($smarty.post.email)}{$smarty.post.email|stripslashes}{/if}" placeholder="{l s='you@example.com'}" />
							</div>
							<div class="fh-field">
								<label class="fh-field__label" for="passwd">{l s='Password'}</label>
								<input class="is_required validate fh-field__input" type="password" data-validate="isPasswd" id="passwd" name="passwd" value="" placeholder="••••••••" />
							</div>
							{block name='displayLoginFormFieldsAfter'}
								{hook h='displayLoginFormFieldsAfter'}
							{/block}
							<p class="fh-auth__forgot"><a href="{$link->getPageLink('password')|escape:'html':'UTF-8'}" title="{l s='Recover your forgotten password'}" rel="nofollow">{l s='Forgot your password?'}</a></p>
							{block name='authentication_login_submit'}
								<div class="fh-form__actions">
									{if isset($back)}<input type="hidden" class="hidden" name="back" value="{$back|escape:'html':'UTF-8'}" />{/if}
									<button type="submit" id="SubmitLogin" name="SubmitLogin" class="fh-btn fh-btn--primary">
										{l s='Sign in'}
										<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg>
									</button>
								</div>
							{/block}
							{block name='displayLoginFormBottom'}
								{hook h="displayLoginFormBottom"}
							{/block}
						</form>
					{/block}
				</section>
			</div>
			{if isset($inOrderProcess) && $inOrderProcess && $PS_GUEST_CHECKOUT_ENABLED}
				{block name='authentication_new_account_form'}
					<section class="fh-card fh-auth__guest">
						<form action="{$link->getPageLink('authentication', true, NULL, "back=$back")|escape:'html':'UTF-8'}" method="post" id="new_account_form" class="fh-form">
							<div id="opc_account_form" style="display: block;">
								<h3 class="fh-auth__card-title">{l s='Instant checkout'}</h3>
								<div class="fh-field">
									<label for="guest_email">{l s='Email address'} <sup>*</sup></label>
									<input type="text" class="is_required validate fh-field__input" data-validate="isEmail" id="guest_email" name="guest_email" value="{if isset($smarty.post.guest_email)}{$smarty.post.guest_email}{/if}" />
								</div>
								<div class="fh-field fh-field--inline">
									<label>{l s='Title'}</label>
									{foreach from=$genders key=k item=gender}
										<div class="radio-inline">
											<label for="id_gender{$gender->id}" class="top">
												<input type="radio" name="id_gender" id="id_gender{$gender->id}" value="{$gender->id}"{if isset($smarty.post.id_gender) && $smarty.post.id_gender == $gender->id} checked="checked"{/if} />
												{$gender->name}
											</label>
										</div>
									{/foreach}
								</div>
								<div class="fh-field-row">
									<div class="fh-field">
										<label for="firstname">{l s='First name'} <sup>*</sup></label>
										<input type="text" class="is_required validate fh-field__input" data-validate="isName" id="firstname" name="firstname" value="{if isset($smarty.post.firstname)}{$smarty.post.firstname}{/if}" />
									</div>
									<div class="fh-field">
										<label for="lastname">{l s='Last name'} <sup>*</sup></label>
										<input type="text" class="is_required validate fh-field__input" data-validate="isName" id="lastname" name="lastname" value="{if isset($smarty.post.lastname)}{$smarty.post.lastname}{/if}" />
									</div>
								</div>
								<div class="fh-field">
									<label>{l s='Date of Birth'}</label>
									<div class="fh-field-row">
										<div class="fh-field">
											<select id="days" name="days" class="fh-field__input">
												<option value="">-</option>
												{foreach from=$days item=day}
													<option value="{$day}" {if ($sl_day == $day)} selected="selected"{/if}>{$day}&nbsp;&nbsp;</option>
												{/foreach}
											</select>
										</div>
										<div class="fh-field">
											<select id="months" name="months" class="fh-field__input">
												<option value="">-</option>
												{foreach from=$months key=k item=month}
													<option value="{$k}" {if ($sl_month == $k)} selected="selected"{/if}>{l s=$month}&nbsp;</option>
												{/foreach}
											</select>
										</div>
										<div class="fh-field">
											<select id="years" name="years" class="fh-field__input">
												<option value="">-</option>
												{foreach from=$years item=year}
													<option value="{$year}" {if ($sl_year == $year)} selected="selected"{/if}>{$year}&nbsp;&nbsp;</option>
												{/foreach}
											</select>
										</div>
									</div>
								</div>
								{if isset($newsletter) && $newsletter}
									<div class="fh-check">
										<label for="newsletter">
											<input type="checkbox" name="newsletter" id="newsletter" value="1" {if isset($smarty.post.newsletter) && $smarty.post.newsletter == '1'}checked="checked"{/if} />
											<span>{l s='Sign up for our newsletter!'}</span>
										</label>
									</div>
								{/if}
								{if isset($optin) && $optin}
									<div class="fh-check">
										<label for="optin">
											<input type="checkbox" name="optin" id="optin" value="1" {if isset($smarty.post.optin) && $smarty.post.optin == '1'}checked="checked"{/if} />
											<span>{l s='Receive special offers from our partners!'}</span>
										</label>
									</div>
								{/if}
								<h3 class="fh-auth__card-title fh-auth__card-title--sub">{l s='Delivery address'}</h3>
								{foreach from=$dlv_all_fields item=field_name}
									{if $field_name eq "company"}
										<div class="fh-field">
											<label for="company">{l s='Company'}{if in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
											<input type="text" class="fh-field__input" id="company" name="company" value="{if isset($smarty.post.company)}{$smarty.post.company}{/if}" />
										</div>
									{elseif $field_name eq "vat_number"}
										<div id="vat_number" style="display:none;">
											<div class="fh-field">
												<label for="vat-number">{l s='VAT number'}{if in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
												<input id="vat-number" type="text" class="fh-field__input" name="vat_number" value="{if isset($smarty.post.vat_number)}{$smarty.post.vat_number}{/if}" />
											</div>
										</div>
									{elseif $field_name eq "dni"}
										{assign var='dniExist' value=true}
										<div class="fh-field">
											<label for="dni">{l s='Identification number'} <sup>*</sup></label>
											<input type="text" name="dni" id="dni" value="{if isset($smarty.post.dni)}{$smarty.post.dni}{/if}" />
											<span class="fh-field__hint">{l s='DNI / NIF / NIE'}</span>
										</div>
									{elseif $field_name eq "address1"}
										<div class="fh-field">
											<label for="address1">{l s='Address'} <sup>*</sup></label>
											<input type="text" class="fh-field__input" name="address1" id="address1" value="{if isset($smarty.post.address1)}{$smarty.post.address1}{/if}" />
										</div>
									{elseif $field_name eq "address2"}
										<div class="fh-field is_customer_param">
											<label for="address2">{l s='Address (Line 2)'}{if in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
											<input type="text" class="fh-field__input" name="address2" id="address2" value="{if isset($smarty.post.address2)}{$smarty.post.address2}{/if}" />
										</div>
									{elseif $field_name eq "postcode"}
										{assign var='postCodeExist' value=true}
										<div class="fh-field">
											<label for="postcode">{l s='Zip/Postal Code'} <sup>*</sup></label>
											<input type="text" class="validate fh-field__input" name="postcode" id="postcode" data-validate="isPostCode" value="{if isset($smarty.post.postcode)}{$smarty.post.postcode}{/if}"/>
										</div>
									{elseif $field_name eq "city"}
										<div class="fh-field">
											<label for="city">{l s='City'} <sup>*</sup></label>
											<input type="text" class="fh-field__input" name="city" id="city" value="{if isset($smarty.post.city)}{$smarty.post.city}{/if}" />
										</div>
									{elseif $field_name eq "Country:name" || $field_name eq "country"}
										<div class="fh-field">
											<label for="id_country">{l s='Country'} <sup>*</sup></label>
											<select name="id_country" id="id_country" class="fh-field__input">
												{foreach from=$countries item=v}
													<option value="{$v.id_country}"{if (isset($smarty.post.id_country) AND  $smarty.post.id_country == $v.id_country) OR (!isset($smarty.post.id_country) && $sl_country == $v.id_country)} selected="selected"{/if}>{$v.name}</option>
												{/foreach}
											</select>
										</div>
									{elseif $field_name eq "State:name"}
										{assign var='stateExist' value=true}
										<div class="fh-field">
											<label for="id_state">{l s='State'} <sup>*</sup></label>
											<select name="id_state" id="id_state" class="fh-field__input">
												<option value="">-</option>
											</select>
										</div>
									{/if}
								{/foreach}
								{if $stateExist eq false}
									<div class="fh-field unvisible">
										<label for="id_state">{l s='State'} <sup>*</sup></label>
										<select name="id_state" id="id_state" class="fh-field__input">
											<option value="">-</option>
										</select>
									</div>
								{/if}
								{if $postCodeExist eq false}
									<div class="fh-field unvisible">
										<label for="postcode">{l s='Zip/Postal Code'} <sup>*</sup></label>
										<input type="text" class="validate fh-field__input" name="postcode" id="postcode" data-validate="isPostCode" value="{if isset($smarty.post.postcode)}{$smarty.post.postcode}{/if}"/>
									</div>
								{/if}
								{if $dniExist eq false}
									<div class="fh-field">
										<label for="dni">{l s='Identification number'} <sup>*</sup></label>
										<input type="text" class="text fh-field__input" name="dni" id="dni" value="{if isset($smarty.post.dni) && $smarty.post.dni}{$smarty.post.dni}{/if}" />
										<span class="fh-field__hint">{l s='DNI / NIF / NIE'}</span>
									</div>
								{/if}
								<div class="{if isset($one_phone_at_least) && $one_phone_at_least}required {/if}fh-field">
									<label for="phone_mobile">{l s='Mobile phone'}{if isset($one_phone_at_least) && $one_phone_at_least} <sup>*</sup>{/if}</label>
									<input type="text" class="fh-field__input" name="phone_mobile" id="phone_mobile" value="{if isset($smarty.post.phone_mobile)}{$smarty.post.phone_mobile}{/if}" />
								</div>
								<input type="hidden" name="alias" id="alias" value="{l s='My address'}" />
								<input type="hidden" name="is_new_customer" id="is_new_customer" value="0" />
								<div class="fh-check">
									<label for="invoice_address">
										<input type="checkbox" name="invoice_address" id="invoice_address"{if (isset($smarty.post.invoice_address) && $smarty.post.invoice_address) || (isset($smarty.post.invoice_address) && $smarty.post.invoice_address)} checked="checked"{/if} autocomplete="off"/>
										<span>{l s='Please use another address for invoice'}</span>
									</label>
								</div>
								<div id="opc_invoice_address"  class="unvisible">
									{assign var=stateExist value=false}
									{assign var=postCodeExist value=false}
									{assign var=dniExist value=false}
									<h3 class="fh-auth__card-title fh-auth__card-title--sub">{l s='Invoice address'}</h3>
									{foreach from=$inv_all_fields item=field_name}
										{if $field_name eq "company"}
											<div class="fh-field">
												<label for="company_invoice">{l s='Company'}{if in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
												<input type="text" class="text fh-field__input" id="company_invoice" name="company_invoice" value="{if isset($smarty.post.company_invoice) && $smarty.post.company_invoice}{$smarty.post.company_invoice}{/if}" />
											</div>
										{elseif $field_name eq "vat_number"}
											<div id="vat_number_block_invoice" style="display:none;">
												<div class="fh-field">
													<label for="vat_number_invoice">{l s='VAT number'}{if in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
													<input type="text" class="fh-field__input" id="vat_number_invoice" name="vat_number_invoice" value="{if isset($smarty.post.vat_number_invoice) && $smarty.post.vat_number_invoice}{$smarty.post.vat_number_invoice}{/if}" />
												</div>
											</div>
										{elseif $field_name eq "dni"}
											{assign var=dniExist value=true}
											<div class="fh-field">
												<label for="dni_invoice">{l s='Identification number'} <sup>*</sup></label>
												<input type="text" class="text fh-field__input" name="dni_invoice" id="dni_invoice" value="{if isset($smarty.post.dni_invoice) && $smarty.post.dni_invoice}{$smarty.post.dni_invoice}{/if}" />
												<span class="fh-field__hint">{l s='DNI / NIF / NIE'}</span>
											</div>
										{elseif $field_name eq "firstname"}
											<div class="fh-field">
												<label for="firstname_invoice">{l s='First name'} <sup>*</sup></label>
												<input type="text" class="fh-field__input" id="firstname_invoice" name="firstname_invoice" value="{if isset($smarty.post.firstname_invoice) && $smarty.post.firstname_invoice}{$smarty.post.firstname_invoice}{/if}" />
											</div>
										{elseif $field_name eq "lastname"}
											<div class="fh-field">
												<label for="lastname_invoice">{l s='Last name'} <sup>*</sup></label>
												<input type="text" class="fh-field__input" id="lastname_invoice" name="lastname_invoice" value="{if isset($smarty.post.lastname_invoice) && $smarty.post.lastname_invoice}{$smarty.post.lastname_invoice}{/if}" />
											</div>
										{elseif $field_name eq "address1"}
											<div class="fh-field">
												<label for="address1_invoice">{l s='Address'} <sup>*</sup></label>
												<input type="text" class="fh-field__input" name="address1_invoice" id="address1_invoice" value="{if isset($smarty.post.address1_invoice) && $smarty.post.address1_invoice}{$smarty.post.address1_invoice}{/if}" />
											</div>
										{elseif $field_name eq "address2"}
											<div class="fh-field is_customer_param">
												<label for="address2_invoice">{l s='Address (Line 2)'}{if in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
												<input type="text" class="fh-field__input" name="address2_invoice" id="address2_invoice" value="{if isset($smarty.post.address2_invoice) && $smarty.post.address2_invoice}{$smarty.post.address2_invoice}{/if}" />
											</div>
										{elseif $field_name eq "postcode"}
											{$postCodeExist = true}
											<div class="fh-field">
												<label for="postcode_invoice">{l s='Zip/Postal Code'} <sup>*</sup></label>
												<input type="text" class="validate fh-field__input" name="postcode_invoice" id="postcode_invoice" data-validate="isPostCode" value="{if isset($smarty.post.postcode_invoice) && $smarty.post.postcode_invoice}{$smarty.post.postcode_invoice}{/if}"/>
											</div>
										{elseif $field_name eq "city"}
											<div class="fh-field">
												<label for="city_invoice">{l s='City'} <sup>*</sup></label>
												<input type="text" class="fh-field__input" name="city_invoice" id="city_invoice" value="{if isset($smarty.post.city_invoice) && $smarty.post.city_invoice}{$smarty.post.city_invoice}{/if}" />
											</div>
										{elseif $field_name eq "country" || $field_name eq "Country:name"}
											<div class="fh-field">
												<label for="id_country_invoice">{l s='Country'} <sup>*</sup></label>
												<select name="id_country_invoice" id="id_country_invoice" class="fh-field__input">
													<option value="">-</option>
													{foreach from=$countries item=v}
														<option value="{$v.id_country}"{if (isset($smarty.post.id_country_invoice) && $smarty.post.id_country_invoice == $v.id_country) OR (!isset($smarty.post.id_country_invoice) && $sl_country == $v.id_country)} selected="selected"{/if}>{$v.name|escape:'html':'UTF-8'}</option>
													{/foreach}
												</select>
											</div>
										{elseif $field_name eq "state" || $field_name eq 'State:name'}
											{$stateExist = true}
											<div class="fh-field" style="display:none;">
												<label for="id_state_invoice">{l s='State'} <sup>*</sup></label>
												<select name="id_state_invoice" id="id_state_invoice" class="fh-field__input">
													<option value="">-</option>
												</select>
											</div>
										{/if}
									{/foreach}
									{if !$postCodeExist}
										<div class="fh-field unvisible">
											<label for="postcode_invoice">{l s='Zip/Postal Code'} <sup>*</sup></label>
											<input type="text" class="fh-field__input" name="postcode_invoice" id="postcode_invoice" value="{if isset($smarty.post.postcode_invoice) && $smarty.post.postcode_invoice}{$smarty.post.postcode_invoice}{/if}"/>
										</div>
									{/if}
									{if !$stateExist}
										<div class="fh-field unvisible">
											<label for="id_state_invoice">{l s='State'} <sup>*</sup></label>
											<select name="id_state_invoice" id="id_state_invoice" class="fh-field__input">
												<option value="">-</option>
											</select>
										</div>
									{/if}
									{if $dniExist eq false}
										<div class="fh-field">
											<label for="dni">{l s='Identification number'} <sup>*</sup></label>
											<input type="text" class="text fh-field__input" name="dni_invoice" id="dni_invoice" value="{if isset($smarty.post.dni_invoice) && $smarty.post.dni_invoice}{$smarty.post.dni_invoice}{/if}" />
											<span class="fh-field__hint">{l s='DNI / NIF / NIE'}</span>
										</div>
									{/if}
									<div class="fh-field is_customer_param">
										<label for="other_invoice">{l s='Additional information'}</label>
										<textarea class="fh-field__input" name="other_invoice" id="other_invoice" cols="26" rows="3"></textarea>
									</div>
									{if isset($one_phone_at_least) && $one_phone_at_least}
										<p class="fh-field__hint required is_customer_param">{l s='You must register at least one phone number.'}</p>
									{/if}
									<div class="fh-field is_customer_param">
										<label for="phone_invoice">{l s='Home phone'}</label>
										<input type="text" class="fh-field__input" name="phone_invoice" id="phone_invoice" value="{if isset($smarty.post.phone_invoice) && $smarty.post.phone_invoice}{$smarty.post.phone_invoice}{/if}" />
									</div>
									<div class="{if isset($one_phone_at_least) && $one_phone_at_least}required {/if}fh-field">
										<label for="phone_mobile_invoice">{l s='Mobile phone'}{if isset($one_phone_at_least) && $one_phone_at_least} <sup>*</sup>{/if}</label>
										<input type="text" class="fh-field__input" name="phone_mobile_invoice" id="phone_mobile_invoice" value="{if isset($smarty.post.phone_mobile_invoice) && $smarty.post.phone_mobile_invoice}{$smarty.post.phone_mobile_invoice}{/if}" />
									</div>
									<input type="hidden" name="alias_invoice" id="alias_invoice" value="{l s='My Invoice address'}" />
								</div>
								{block name='displayCustomerAccountForm'}
									{$HOOK_CREATE_ACCOUNT_FORM}
								{/block}
							</div>
							<p class="fh-auth__guest-actions">
								<span class="fh-field__hint"><sup>*</sup>{l s='Required field'}</span>
								<input type="hidden" name="display_guest_checkout" value="1" />
								{block name='authentication_guest_submit'}
									<button type="submit" class="fh-btn fh-btn--primary" name="submitGuestAccount" id="submitGuestAccount">
										{l s='Proceed to checkout'}
										<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg>
									</button>
								{/block}
							</p>
						</form>
					</section>
				{/block}
			{/if}
		</div>
	{else}
		{block name='authentication_account_creation_form'}
			<section class="fh-card fh-auth__register">
				<form action="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" method="post" id="account-creation_form" class="fh-form">
					{block name='displayCustomerAccountFormTop'}
						{$HOOK_CREATE_ACCOUNT_TOP}
					{/block}
					<div class="account_creation">
						<h3 class="fh-auth__card-title">{l s='Your personal information'}</h3>
						<div class="fh-field fh-field--inline">
							<label>{l s='Title'}</label>
							{foreach from=$genders key=k item=gender}
								<div class="radio-inline">
									<label for="id_gender{$gender->id}" class="top">
										<input checked="" type="radio" name="id_gender" id="id_gender{$gender->id}" value="{$gender->id}" {if isset($smarty.post.id_gender) && $smarty.post.id_gender == $gender->id}checked="checked"{/if} />
										{$gender->name}
									</label>
								</div>
							{/foreach}
						</div>
						<div class="fh-field-row">
							<div class="fh-field">
								<label for="customer_firstname">{l s='First name'} <sup>*</sup></label>
								<input onkeyup="$('#firstname').val(this.value);" type="text" class="is_required validate fh-field__input" data-validate="isName" id="customer_firstname" name="customer_firstname" value="{if isset($smarty.post.customer_firstname)}{$smarty.post.customer_firstname}{/if}" />
							</div>
							<div class="fh-field">
								<label for="customer_lastname">{l s='Last name'} <sup>*</sup></label>
								<input onkeyup="$('#lastname').val(this.value);" type="text" class="is_required validate fh-field__input" data-validate="isName" id="customer_lastname" name="customer_lastname" value="{if isset($smarty.post.customer_lastname)}{$smarty.post.customer_lastname}{/if}" />
							</div>
						</div>
						<div class="fh-field">
							<label for="email">{l s='Email'} <sup>*</sup></label>
							<input type="email" class="is_required validate fh-field__input" data-validate="isEmail" id="email" name="email" value="{if isset($smarty.post.email)}{$smarty.post.email}{/if}" />
						</div>
						<div class="fh-field">
							<label for="customer_phone">{l s='Phone'} {if isset($one_phone_at_least) && $one_phone_at_least}<sup>*</sup>{/if}</label>
							<input onkeyup="$('#phone').val(this.value);" class="is_required validate fh-field__input" data-validate="isPhoneNumber" type="phone" name="customer_phone" id="customer_phone" value="{if isset($smarty.post.customer_phone)}{$smarty.post.customer_phone}{/if}" />
						</div>
						<div class="fh-field">
							<label for="passwd">{l s='Password'} <sup>*</sup></label>
							<input type="password" class="is_required validate fh-field__input" data-validate="isPasswd" name="passwd" id="passwd" />
							<span class="fh-field__hint">{l s='(Five characters minimum)'}</span>
						</div>
						{if isset($birthday) && $birthday}
							<div class="fh-field">
								<label>{l s='Date of Birth'}</label>
								<div class="fh-field-row">
									<div class="fh-field">
										<select id="days" name="days" class="fh-field__input">
											<option value="">-</option>
											{foreach from=$days item=day}
												<option value="{$day}" {if ($sl_day == $day)} selected="selected"{/if}>{$day}&nbsp;&nbsp;</option>
											{/foreach}
										</select>
									</div>
									<div class="fh-field">
										<select id="months" name="months" class="fh-field__input">
											<option value="">-</option>
											{foreach from=$months key=k item=month}
												<option value="{$k}" {if ($sl_month == $k)} selected="selected"{/if}>{l s=$month}&nbsp;</option>
											{/foreach}
										</select>
									</div>
									<div class="fh-field">
										<select id="years" name="years" class="fh-field__input">
											<option value="">-</option>
											{foreach from=$years item=year}
												<option value="{$year}" {if ($sl_year == $year)} selected="selected"{/if}>{$year}&nbsp;&nbsp;</option>
											{/foreach}
										</select>
									</div>
								</div>
							</div>
						{/if}
						{if isset($newsletter) && $newsletter}
							<div class="fh-check">
								<input type="checkbox" name="newsletter" id="newsletter" value="1" {if isset($smarty.post.newsletter) AND $smarty.post.newsletter == 1} checked="checked"{/if} />
								<label for="newsletter">{l s='Sign up for our newsletter!'}</label>
								{if array_key_exists('newsletter', $field_required)}
									<sup> *</sup>
								{/if}
							</div>
						{/if}
						{if isset($optin) && $optin}
							<div class="fh-check">
								<input type="checkbox" name="optin" id="optin" value="1" {if isset($smarty.post.optin) AND $smarty.post.optin == 1} checked="checked"{/if} />
								<label for="optin">{l s='Receive special offers from our partners!'}</label>
								{if array_key_exists('optin', $field_required)}
									<sup> *</sup>
								{/if}
							</div>
						{/if}
					</div>
					{if $b2b_enable}
						<div class="account_creation">
							<h3 class="fh-auth__card-title fh-auth__card-title--sub">{l s='Your company information'}</h3>
							<div class="fh-field">
								<label for="">{l s='Company'}</label>
								<input type="text" class="fh-field__input" id="company" name="company" value="{if isset($smarty.post.company)}{$smarty.post.company}{/if}" />
							</div>
							<div class="fh-field">
								<label for="siret">{l s='SIRET'}</label>
								<input type="text" class="fh-field__input" id="siret" name="siret" value="{if isset($smarty.post.siret)}{$smarty.post.siret}{/if}" />
							</div>
							<div class="fh-field">
								<label for="ape">{l s='APE'}</label>
								<input type="text" class="fh-field__input" id="ape" name="ape" value="{if isset($smarty.post.ape)}{$smarty.post.ape}{/if}" />
							</div>
							<div class="fh-field">
								<label for="website">{l s='Website'}</label>
								<input type="text" class="fh-field__input" id="website" name="website" value="{if isset($smarty.post.website)}{$smarty.post.website}{/if}" />
							</div>
						</div>
					{/if}
					{if isset($PS_REGISTRATION_PROCESS_TYPE) && $PS_REGISTRATION_PROCESS_TYPE}
						<div class="account_creation">
							<h3 class="fh-auth__card-title fh-auth__card-title--sub">{l s='Your address'}</h3>
							{foreach from=$dlv_all_fields item=field_name}
								{if $field_name eq "company"}
									{if !$b2b_enable}
										<div class="fh-field">
											<label for="company">{l s='Company'}{if in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
											<input type="text" class="fh-field__input" id="company" name="company" value="{if isset($smarty.post.company)}{$smarty.post.company}{/if}" />
										</div>
									{/if}
								{elseif $field_name eq "vat_number"}
									<div id="vat_number" style="display:none;">
										<div class="fh-field">
											<label for="vat_number">{l s='VAT number'}{if in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
											<input type="text" class="fh-field__input" id="vat_number" name="vat_number" value="{if isset($smarty.post.vat_number)}{$smarty.post.vat_number}{/if}" />
										</div>
									</div>
								{elseif $field_name eq "firstname"}
									<div class="fh-field">
										<label for="firstname">{l s='First name'} <sup>*</sup></label>
										<input type="text" class="fh-field__input" id="firstname" name="firstname" value="{if isset($smarty.post.firstname)}{$smarty.post.firstname}{/if}" />
									</div>
								{elseif $field_name eq "lastname"}
									<div class="fh-field">
										<label for="lastname">{l s='Last name'} <sup>*</sup></label>
										<input type="text" class="fh-field__input" id="lastname" name="lastname" value="{if isset($smarty.post.lastname)}{$smarty.post.lastname}{/if}" />
									</div>
								{elseif $field_name eq "address1"}
									<div class="fh-field">
										<label for="address1">{l s='Address'} <sup>*</sup></label>
										<input type="text" class="fh-field__input" name="address1" id="address1" value="{if isset($smarty.post.address1)}{$smarty.post.address1}{/if}" />
										<span class="fh-field__hint">{l s='Street address, P.O. Box, Company name, etc.'}</span>
									</div>
								{elseif $field_name eq "address2"}
									<div class="fh-field is_customer_param">
										<label for="address2">{l s='Address (Line 2)'}{if in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
										<input type="text" class="fh-field__input" name="address2" id="address2" value="{if isset($smarty.post.address2)}{$smarty.post.address2}{/if}" />
										<span class="fh-field__hint">{l s='Apartment, suite, unit, building, floor, etc...'}</span>
									</div>
								{elseif $field_name eq "postcode"}
									{assign var='postCodeExist' value=true}
									<div class="fh-field">
										<label for="postcode">{l s='Zip/Postal Code'} <sup>*</sup></label>
										<input type="text" class="validate fh-field__input" name="postcode" id="postcode" data-validate="isPostCode" value="{if isset($smarty.post.postcode)}{$smarty.post.postcode}{/if}"/>
									</div>
								{elseif $field_name eq "city"}
									<div class="fh-field">
										<label for="city">{l s='City'} <sup>*</sup></label>
										<input type="text" class="fh-field__input" name="city" id="city" value="{if isset($smarty.post.city)}{$smarty.post.city}{/if}" />
									</div>
								{elseif $field_name eq "Country:name" || $field_name eq "country"}
									<div class="fh-field">
										<label for="id_country">{l s='Country'} <sup>*</sup></label>
										<select name="id_country" id="id_country" class="fh-field__input">
											<option value="">-</option>
											{foreach from=$countries item=v}
												<option value="{$v.id_country}"{if (isset($smarty.post.id_country) AND $smarty.post.id_country == $v.id_country) OR (!isset($smarty.post.id_country) && $sl_country == $v.id_country)} selected="selected"{/if}>{$v.name}</option>
											{/foreach}
										</select>
									</div>
								{elseif $field_name eq "State:name" || $field_name eq 'state'}
									{assign var='stateExist' value=true}
									<div class="fh-field">
										<label for="id_state">{l s='State'} <sup>*</sup></label>
										<select name="id_state" id="id_state" class="fh-field__input">
											<option value="">-</option>
										</select>
									</div>
								{/if}
							{/foreach}
							{if $postCodeExist eq false}
								<div class="fh-field unvisible">
									<label for="postcode">{l s='Zip/Postal Code'} <sup>*</sup></label>
									<input type="text" class="validate fh-field__input" name="postcode" id="postcode" data-validate="isPostCode" value="{if isset($smarty.post.postcode)}{$smarty.post.postcode}{/if}"/>
								</div>
							{/if}
							{if $stateExist eq false}
								<div class="fh-field unvisible">
									<label for="id_state">{l s='State'} <sup>*</sup></label>
									<select name="id_state" id="id_state" class="fh-field__input">
										<option value="">-</option>
									</select>
								</div>
							{/if}
							<div class="fh-field">
								<label for="other">{l s='Additional information'}</label>
								<textarea class="fh-field__input" name="other" id="other" cols="26" rows="3">{if isset($smarty.post.other)}{$smarty.post.other}{/if}</textarea>
							</div>
							{if isset($one_phone_at_least) && $one_phone_at_least}
								<p class="fh-field__hint">{l s='You must register at least one phone number.'}</p>
							{/if}
							<div class="fh-field">
								<label class="" for="phone">{l s='Home phone'}</label>
								<input type="text" class="fh-field__input" name="phone" id="phone" value="{if isset($smarty.post.phone)}{$smarty.post.phone}{/if}" />
							</div>
							<div class="{if isset($one_phone_at_least) && $one_phone_at_least}required {/if}fh-field">
								<label for="phone_mobile">{l s='Mobile phone'}{if isset($one_phone_at_least) && $one_phone_at_least} <sup>**</sup>{/if}</label>
								<input type="text" class="fh-field__input" name="phone_mobile" id="phone_mobile" value="{if isset($smarty.post.phone_mobile)}{$smarty.post.phone_mobile}{/if}" />
							</div>
							<div class="fh-field">
								<label for="alias">{l s='Assign an address alias for future reference.'} <sup>*</sup></label>
								<input type="text" class="fh-field__input" name="alias" id="alias" value="{if isset($smarty.post.alias)}{$smarty.post.alias}{else}{l s='My address'}{/if}" />
							</div>
						</div>
						<div class="account_creation">
							<h3 class="fh-auth__card-title fh-auth__card-title--sub">{l s='Tax identification'}</h3>
							<div class="fh-field">
								<label for="dni">{l s='Identification number'} <sup>*</sup></label>
								<input type="text" class="fh-field__input" name="dni" id="dni" value="{if isset($smarty.post.dni)}{$smarty.post.dni}{/if}" />
								<span class="fh-field__hint">{l s='DNI / NIF / NIE'}</span>
							</div>
						</div>
					{/if}
					{block name='displayCustomerAccountForm'}
						{$HOOK_CREATE_ACCOUNT_FORM}
					{/block}
					<div class="fh-form__actions">
						<input type="hidden" name="email_create" value="1" />
						<input type="hidden" name="is_new_customer" value="1" />
						{if isset($back)}<input type="hidden" class="hidden" name="back" value="{$back|escape:'html':'UTF-8'}" />{/if}
						{block name='authentication_account_submit'}
							<button type="submit" name="submitAccount" id="submitAccount" class="fh-btn fh-btn--primary">
								{l s='Register'}
								<svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-arrow-right"/></svg>
							</button>
						{/block}
						<p class="fh-field__hint"><sup>*</sup>{l s='Required field'}</p>
					</div>
				</form>
			</section>
		{/block}
	{/if}
	{block name='authentication_js_vars'}
		{strip}
		{if isset($smarty.post.id_state) && $smarty.post.id_state}
			{addJsDef idSelectedState=$smarty.post.id_state|intval}
		{elseif isset($address->id_state) && $address->id_state}
			{addJsDef idSelectedState=$address->id_state|intval}
		{else}
			{addJsDef idSelectedState=false}
		{/if}
		{if isset($smarty.post.id_state_invoice) && isset($smarty.post.id_state_invoice) && $smarty.post.id_state_invoice}
			{addJsDef idSelectedStateInvoice=$smarty.post.id_state_invoice|intval}
		{else}
			{addJsDef idSelectedStateInvoice=false}
		{/if}
		{if isset($smarty.post.id_country) && $smarty.post.id_country}
			{addJsDef idSelectedCountry=$smarty.post.id_country|intval}
		{elseif isset($address->id_country) && $address->id_country}
			{addJsDef idSelectedCountry=$address->id_country|intval}
		{else}
			{addJsDef idSelectedCountry=false}
		{/if}
		{if isset($smarty.post.id_country_invoice) && isset($smarty.post.id_country_invoice) && $smarty.post.id_country_invoice}
			{addJsDef idSelectedCountryInvoice=$smarty.post.id_country_invoice|intval}
		{else}
			{addJsDef idSelectedCountryInvoice=false}
		{/if}
		{if isset($countries)}
			{addJsDef countries=$countries}
		{/if}
		{if isset($email_create) && $email_create}
			{addJsDef email_create=$email_create|boolval}
		{else}
			{addJsDef email_create=false}
		{/if}
		{/strip}
	{/block}
{/block}
