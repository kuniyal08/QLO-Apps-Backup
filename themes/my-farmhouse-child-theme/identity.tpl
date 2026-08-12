{*
* Farmhouse: premium personal information form.
* Preserves all field ids/names, data-validate, birthday selects,
* the gender radios, B2B section and HOOK_CUSTOMER_IDENTITY_FORM.
*}

{block name='identity'}
	{capture name=path}
		<a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">
			{l s='My account'}
		</a>
		<span class="navigation-pipe">
			{$navigationPipe}
		</span>
		<span class="navigation_page">
			{l s='Personal information'}
		</span>
	{/capture}
	<div class="fh-account">
		<p class="fh-eyebrow">{l s='Your profile'}</p>
		{block name='identity_heading'}
			<h1 class="fh-account__title">{l s='Personal information'}</h1>
		{/block}
		{block name='errors'}
			{include file="$tpl_dir./errors.tpl"}
		{/block}

		{if isset($confirmation) && $confirmation}
			<div class="fh-alert fh-alert--success">
				{l s='Your personal information has been successfully updated.'}
				{if isset($pwd_changed)}<br />{l s='Your password has been sent to your email:'} {$email}{/if}
			</div>
		{else}
			<p class="fh-account__copy">{l s='Please be sure to update your personal information if it has changed.'}</p>
			<section class="fh-card fh-account__form-card">
				<p class="fh-field__hint"><sup>*</sup>{l s='Required field'}</p>
				{block name='identity_form'}
					<form action="{$link->getPageLink('identity', true)|escape:'html':'UTF-8'}" method="post" class="fh-form" id="identity_form">
						<fieldset>
							<div class="fh-field fh-field--inline">
								<label class="fh-field__label">{l s='Social title'}</label>
								{foreach from=$genders key=k item=gender}
									<div class="fh-check fh-check--radio">
										<input type="radio" name="id_gender" id="id_gender{$gender->id}" value="{$gender->id|intval}" {if isset($smarty.post.id_gender) && $smarty.post.id_gender == $gender->id}checked="checked"{/if} />
										<label for="id_gender{$gender->id}">{$gender->name}</label>
									</div>
								{/foreach}
							</div>
							<div class="fh-field-row">
								<div class="fh-field form-group required">
									<label class="fh-field__label" for="firstname">{l s='First name'} <sup>*</sup></label>
									<input class="fh-field__input is_required validate" data-validate="isName" type="text" id="firstname" name="firstname" value="{$smarty.post.firstname}" />
								</div>
								<div class="fh-field form-group required">
									<label class="fh-field__label" for="lastname">{l s='Last name'} <sup>*</sup></label>
									<input class="fh-field__input is_required validate" data-validate="isName" type="text" name="lastname" id="lastname" value="{$smarty.post.lastname}" />
								</div>
							</div>
							<div class="fh-field form-group required">
								<label class="fh-field__label" for="email">{l s='E-mail address'} <sup>*</sup></label>
								<input class="fh-field__input is_required validate" data-validate="isEmail" type="email" name="email" id="email" value="{$smarty.post.email}" />
							</div>
							<div class="fh-field form-group {if isset($one_phone_at_least) && $one_phone_at_least}required{/if}">
								<label class="fh-field__label" for="phone">{l s='Phone'}{if isset($one_phone_at_least) && $one_phone_at_least} <sup>*</sup>{/if}</label>
								<input class="fh-field__input validate" data-validate="isPhoneNumber" type="tel" name="phone" id="phone" value="{$smarty.post.phone}" />
							</div>
							{if isset($birthday) && $birthday}
								<div class="fh-field">
									<label class="fh-field__label">{l s='Date of Birth'}</label>
									<div class="fh-field-row fh-field-row--3">
										<select name="days" id="days" class="fh-field__input">
											<option value="">-</option>
											{foreach from=$days item=v}
												<option value="{$v}" {if ($sl_day == $v)}selected="selected"{/if}>{$v}&nbsp;&nbsp;</option>
											{/foreach}
										</select>
										<select id="months" name="months" class="fh-field__input">
											<option value="">-</option>
											{foreach from=$months key=k item=v}
												<option value="{$k}" {if ($sl_month == $k)}selected="selected"{/if}>{l s=$v}&nbsp;</option>
											{/foreach}
										</select>
										<select id="years" name="years" class="fh-field__input">
											<option value="">-</option>
											{foreach from=$years item=v}
												<option value="{$v}" {if ($sl_year == $v)}selected="selected"{/if}>{$v}&nbsp;&nbsp;</option>
											{/foreach}
										</select>
									</div>
								</div>
							{/if}
							<div class="fh-field form-group required">
								<label class="fh-field__label" for="old_passwd">{l s='Current Password'} <sup>*</sup></label>
								<input class="fh-field__input is_required validate" type="password" data-validate="isPasswd" name="old_passwd" id="old_passwd" />
							</div>
							<div class="fh-field-row">
								<div class="fh-field form-group password">
									<label class="fh-field__label" for="passwd">{l s='New Password'}</label>
									<input class="fh-field__input validate" type="password" data-validate="isPasswd" name="passwd" id="passwd" />
								</div>
								<div class="fh-field form-group password">
									<label class="fh-field__label" for="confirmation">{l s='Confirmation'}</label>
									<input class="fh-field__input validate" type="password" data-validate="isPasswd" name="confirmation" id="confirmation" />
								</div>
							</div>
							{if isset($newsletter) && $newsletter}
								<div class="fh-check">
									<input type="checkbox" id="newsletter" name="newsletter" value="1" {if isset($smarty.post.newsletter) && $smarty.post.newsletter == 1} checked="checked"{/if}/>
									<label for="newsletter">
										{l s='Sign up for our newsletter!'}
										{if isset($required_fields) && array_key_exists('newsletter', $field_required)}
										<sup> *</sup>
										{/if}
									</label>
								</div>
							{/if}
							{if isset($optin) && $optin}
								<div class="fh-check">
									<input type="checkbox" name="optin" id="optin" value="1" {if isset($smarty.post.optin) && $smarty.post.optin == 1} checked="checked"{/if}/>
									<label for="optin">
										{l s='Receive special offers from our partners!'}
										{if isset($required_fields) && array_key_exists('optin', $field_required)}
										<sup> *</sup>
										{/if}
									</label>
								</div>
							{/if}
							{if $b2b_enable}
								<p class="fh-auth__card-title fh-auth__card-title--sub">{l s='Your company information'}</p>
								<div class="fh-field form-group">
									<label class="fh-field__label" for="company">{l s='Company'}</label>
									<input type="text" class="fh-field__input" id="company" name="company" value="{if isset($smarty.post.company)}{$smarty.post.company}{/if}" />
								</div>
								<div class="fh-field-row">
									<div class="fh-field form-group">
										<label class="fh-field__label" for="siret">{l s='SIRET'}</label>
										<input type="text" class="fh-field__input" id="siret" name="siret" value="{if isset($smarty.post.siret)}{$smarty.post.siret}{/if}" />
									</div>
									<div class="fh-field form-group">
										<label class="fh-field__label" for="ape">{l s='APE'}</label>
										<input type="text" class="fh-field__input" id="ape" name="ape" value="{if isset($smarty.post.ape)}{$smarty.post.ape}{/if}" />
									</div>
								</div>
								<div class="fh-field form-group">
									<label class="fh-field__label" for="website">{l s='Website'}</label>
									<input type="text" class="fh-field__input" id="website" name="website" value="{if isset($smarty.post.website)}{$smarty.post.website}{/if}" />
								</div>
							{/if}

							{block name='displayCustomerIdentityForm'}
								{if isset($HOOK_CUSTOMER_IDENTITY_FORM)}
									{$HOOK_CUSTOMER_IDENTITY_FORM}
								{/if}
							{/block}
							<div class="fh-form__actions">
								<button type="submit" name="submitIdentity" class="fh-btn fh-btn--primary">
									{l s='Save'}
								</button>
								<a class="fh-btn fh-btn--ghost" href="{$link->getPageLink('my-account', true)}">
									{l s='Back to My account'}
								</a>
							</div>
						</fieldset>
					</form>
				{/block}
			</section>
		{/if}
	</div>
{/block}
