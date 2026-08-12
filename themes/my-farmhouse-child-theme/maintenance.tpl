{*
* Farmhouse: premium maintenance page — self-contained (brand styles inline).
* Preserves the employee login contract (email/passwd/SubmitLogin, clicker toggle)
* and the language switcher.
*}

<!DOCTYPE html>
<html lang="{$language_code|escape:'html':'UTF-8'}">

<head>
	<meta charset="utf-8">
	<title>{$meta_title|escape:'html':'UTF-8'}</title>
	{if isset($meta_description)}
		<meta name="description" content="{$meta_description|escape:'html':'UTF-8'}">
	{/if}
	{if isset($meta_keywords)}
		<meta name="keywords" content="{$meta_keywords|escape:'html':'UTF-8'}">
	{/if}
	<meta name="robots" content="{if isset($nobots)}no{/if}index,follow">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="shortcut icon" href="{$favicon_url}">
	<link href="{$css_dir}maintenance.css" rel="stylesheet">
	<script src="{$base_dir}js/jquery/jquery-1.11.0.min.js"></script>
	<script src="{$js_dir}maintenance.js"></script>
	<style>
		:root { --fh-ink:#1f1b16; --fh-muted:#6e675c; --fh-paper:#f7f4ef; --fh-card:#ffffff; --fh-primary:#2f4a3c; --fh-terracotta:#c46a3b; --fh-border:rgba(31,27,22,.12); --fh-display:'Fraunces', Georgia, serif; }
		body { background: var(--fh-paper); font-family: Manrope, 'Segoe UI', system-ui, sans-serif; color: var(--fh-ink); }
		.fhm-main { min-height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 48px 20px; text-align: center; box-sizing: border-box; }
		.fhm-brand { font-family: var(--fh-display); font-size: 30px; font-weight: 600; letter-spacing: -.01em; margin: 0 0 4px; }
		.fhm-brand span { color: var(--fh-terracotta); }
		.fhm-tag { font-size: 13px; letter-spacing: .14em; text-transform: uppercase; color: var(--fh-muted); margin: 0 0 40px; }
		.fhm-card { background: var(--fh-card); border: 1px solid var(--fh-border); border-radius: 20px; box-shadow: 0 1px 2px rgba(31,27,22,.05), 0 12px 32px rgba(31,27,22,.08); padding: 48px 40px; max-width: 460px; width: 100%; box-sizing: border-box; }
		.fhm-card h2 { font-family: var(--fh-display); font-size: 34px; line-height: 1.15; margin: 0 0 14px; }
		.fhm-card p { color: var(--fh-muted); line-height: 1.6; margin: 0 0 10px; }
		.fhm-clicker { display: inline-block; margin-top: 18px; color: var(--fh-primary); font-weight: 700; font-size: 14px; cursor: pointer; border-bottom: 1px dashed var(--fh-primary); padding-bottom: 2px; }
		.fhm-field { margin: 18px 0; text-align: left; }
		.fhm-field label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 7px; }
		.fhm-field input { width: 100%; height: 48px; padding: 10px 14px; font-size: 15px; border: 1px solid var(--fh-border); border-radius: 12px; box-sizing: border-box; background: #fff; }
		.fhm-field input:focus { outline: none; border-color: var(--fh-primary); box-shadow: 0 0 0 3px rgba(47,74,60,.14); }
		.fhm-btn { min-height: 48px; border: none; border-radius: 999px; padding: 0 28px; font-size: 15px; font-weight: 700; cursor: pointer; margin: 8px 6px 0; }
		.fhm-btn--primary { background: var(--fh-primary); color: #fff; }
		.fhm-btn--ghost { background: transparent; color: var(--fh-ink); border: 1px solid var(--fh-border); }
		.fhm-errors { background: rgba(163,69,47,.08); border: 1px solid rgba(163,69,47,.35); color: #a3452f; border-radius: 12px; padding: 14px 18px; text-align: left; margin-bottom: 18px; font-size: 14px; }
		.fhm-errors ol { margin: 6px 0 0 18px; }
		.fhm-lang { position: absolute; top: 24px; right: 24px; font-size: 14px; color: var(--fh-muted); }
		.fhm-lang a { color: var(--fh-primary); text-decoration: none; }
		.fhm-lang .disabled { color: var(--fh-ink); font-weight: 700; }
		@media (max-width: 480px) { .fhm-card { padding: 36px 24px; } }
	</style>
</head>

<body>
	<div id="maintenance">
		{if count($languages) > 1}
			<div class="fhm-lang">
				{foreach from=$languages item=language}
					{if $language.iso_code != $lang_iso}
						<a href="{$link->getLanguageLink($language.id_lang)|escape:'html':'UTF-8'}" title="{$language.name}">{$language.name|regex_replace:'/\s\(.*\)$/':''}</a>
					{else}
						<span class="disabled">{$language.name|regex_replace:'/\s\(.*\)$/':''}</span>
					{/if}
				{/foreach}
			</div>
		{/if}
		<div class="fhm-main">
			<p class="fhm-brand">My Farmhouse <span>&middot;</span> Hotel</p>
			<p class="fhm-tag">{l s='Rural stays and local stories'}</p>
			{if isset($errors) && $errors}
				<div class="fhm-errors">
					<strong>{l s='Error!'}</strong>
					<ol>
						{foreach from=$errors key=k item=error}
							<li>{$error}</li>
						{/foreach}
					</ol>
				</div>
			{/if}
			<div class="fhm-card">
				<h2>{l s='We\'ll be back soon.'}</h2>
				<p>{l s='We are currently updating our site and will be back really soon.'}</p>
				<p>{l s='Thanks for your patience!'}</p>
				{if isset($allowEmployee) && $allowEmployee}
					<div>
						<p class="fhm-clicker blue" tabindex="1">{l s='Are you a member?'}</p>
						<div class="login-form-wrap" {if !isset($smarty.post.SubmitLogin)}style="display:none;"{/if}>
							<form action="" method="post">
								<div class="fhm-field">
									<label for="email">{l s='Email address'}</label>
									<input type="email" id="email" name="email" placeholder="{l s='Email'}" {if isset($smarty.post.SubmitLogin)}value="{$smarty.post.email|escape:'html':'UTF-8'}"{/if}>
								</div>
								<div class="fhm-field">
									<label for="passwd">{l s='Password'}</label>
									<input type="password" id="passwd" name="passwd" placeholder="{l s='Password'}" value="">
								</div>
								<button type="submit" id="SubmitLogin" name="SubmitLogin" class="fhm-btn fhm-btn--primary">
									{l s='Log in'}
								</button>
								<button type="button" id="cancelLogin" name="cancelLogin" class="fhm-btn fhm-btn--ghost">
									{l s='Cancel'}
								</button>
							</form>
						</div>
					</div>
				{/if}
			</div>
		</div>
	</div>
</body>

</html>