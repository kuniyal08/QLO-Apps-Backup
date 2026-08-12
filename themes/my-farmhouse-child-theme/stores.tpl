{*
* Farmhouse: premium stores — simplified list as cards, map branch restyled.
* Preserves the stores.js contract (addressInput, radiusSelect, locationSelect,
* stores-table, and all map addJsDef vars).
*}

{capture name=path}{l s='Our stores'}{/capture}

<div class="fh-account">
	<p class="fh-eyebrow">{l s='Find us'}</p>
	<h1 class="fh-account__title">{l s='Our stores'}</h1>

	{if $simplifiedStoresDiplay}
		{if $stores|@count}
			<p class="fh-account__copy">
				<strong>{l s='Here you can find our store locations. Please feel free to contact us:'}</strong>
			</p>
			<ul class="fh-address-grid">
				{foreach $stores as $store}
					<li>
						<div class="fh-card fh-address-card">
							{assign value=$store.id_store var="id_store"}
							{if $store.has_picture}
								<div class="fh-address-card__media">
									<img src="{$img_store_dir}{$store.id_store}-medium_default.jpg" alt="{$store.name|escape:'html':'UTF-8'}" width="{$mediumSize.width}" height="{$mediumSize.height}"/>
								</div>
							{/if}
							<p class="fh-address-card__alias">{$store.name|escape:'html':'UTF-8'}</p>
							<div class="fh-address-card__body">
								{foreach from=$addresses_formated.$id_store.ordered name=adr_loop item=pattern}
									{assign var=addressKey value=" "|explode:$pattern}
									{foreach from=$addressKey item=key name="word_loop"}
										<span {if isset($addresses_style[$key])} class="{$addresses_style[$key]}"{/if}>
											{$addresses_formated.$id_store.formated[$key|replace:',':'']|escape:'html':'UTF-8'}
										</span>
									{/foreach}
								{/foreach}
								{if $store.phone}<br/>{l s='Phone:'} {$store.phone|escape:'html':'UTF-8'}{/if}
								{if $store.fax}<br/>{l s='Fax:'} {$store.fax|escape:'html':'UTF-8'}{/if}
								{if $store.email}<br/>{l s='Email:'} {$store.email|escape:'html':'UTF-8'}{/if}
								{if $store.note}<br/><br/>{$store.note|escape:'html':'UTF-8'|nl2br}{/if}
							</div>
							{if isset($store.working_hours)}
								<div class="fh-address-card__hours">
									<span class="fh-eyebrow">{l s='Working hours'}</span>
									{$store.working_hours}
								</div>
							{/if}
						</div>
					</li>
				{/foreach}
			</ul>
		{/if}
	{else}
		<div id="map" class="fh-stores__map"></div>
		<p class="fh-account__copy">
			<strong>{l s='Enter a location (e.g. zip/postal code, address, city or country) in order to find the nearest stores.'}</strong>
		</p>
		<section class="fh-card fh-account__form-card fh-stores__search">
			<div class="fh-field-row">
				<div class="fh-field">
					<label class="fh-field__label" for="addressInput">{l s='Your location:'}</label>
					<input class="fh-field__input grey" type="text" name="location" id="addressInput" value="{l s='Address, zip / postal code, city, state or country'}" />
				</div>
				<div class="fh-field">
					<label class="fh-field__label" for="radiusSelect">{l s='Radius:'}</label>
					<div class="fh-field--inline">
						<select name="radius" id="radiusSelect" class="fh-field__input">
							<option value="15">15</option>
							<option value="25">25</option>
							<option value="50">50</option>
							<option value="100">100</option>
						</select>
						<img src="{$img_ps_dir}loader.gif" class="middle" alt="" id="stores_loader" />
					</div>
				</div>
			</div>
			<div class="fh-form__actions">
				<button name="search_locations" class="fh-btn fh-btn--primary">
					{l s='Search'}
				</button>
			</div>
		</section>
		<div class="fh-stores__results">
			<select id="locationSelect" class="fh-field__input">
				<option>-</option>
			</select>

			<div class="fh-card fh-table-wrap">
				<table id="stores-table" class="table fh-table">
					<thead>
						<tr>
							<th class="num">#</th>
							<th>{l s='Store'}</th>
							<th>{l s='Address'}</th>
							<th>{l s='Distance'}</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
	{/if}
	{strip}
	{addJsDef map=''}
	{addJsDef markers=array()}
	{addJsDef infoWindow=''}
	{addJsDef locationSelect=''}
	{addJsDef defaultLat=$defaultLat}
	{addJsDef defaultLong=$defaultLong}
	{addJsDef hasStoreIcon=$hasStoreIcon}
	{addJsDef distance_unit=$distance_unit}
	{addJsDef img_store_dir=$img_store_dir}
	{addJsDef img_ps_dir=$img_ps_dir}
	{addJsDef searchUrl=$searchUrl}
	{addJsDef logo_store=$logo_store}
	{addJsDefL name=translation_1}{l s='No stores were found. Please try selecting a wider radius.' js=1}{/addJsDefL}
	{addJsDefL name=translation_2}{l s='store found -- see details:' js=1}{/addJsDefL}
	{addJsDefL name=translation_3}{l s='stores found -- view all results:' js=1}{/addJsDefL}
	{addJsDefL name=translation_4}{l s='Phone:' js=1}{/addJsDefL}
	{addJsDefL name=translation_5}{l s='Get directions' js=1}{/addJsDefL}
	{addJsDefL name=translation_6}{l s='Not found' js=1}{/addJsDefL}
	{/strip}
</div>