{block name='testimonial_block'}
{if isset($testimonials_data) && $testimonials_data}
<section id="hotelTestimonialBlock" class="ru-section ru-section--sage"><div class="ru-container"><header class="ru-section-head"><div><p class="ru-eyebrow">{l s='Guest notes' mod='wktestimonialblock'}</p><h2>{l s='The kinds of weekends people remember' mod='wktestimonialblock'}</h2></div></header><div class="ru-testimonials">{foreach $testimonials_data as $testimonial}<article class="ru-testimonial"><div class="ru-testimonial__quote" aria-hidden="true">“</div><blockquote>{$testimonial.testimonial_content|escape:'html':'UTF-8'}</blockquote><cite>{if $testimonial.img_url}<img src="{$testimonial.img_url|escape:'html':'UTF-8'}" alt=""> {/if}{$testimonial.name|escape:'html':'UTF-8'}{if $testimonial.designation}, {$testimonial.designation|escape:'html':'UTF-8'}{/if}</cite></article>{/foreach}</div></div></section>
{/if}
{/block}
