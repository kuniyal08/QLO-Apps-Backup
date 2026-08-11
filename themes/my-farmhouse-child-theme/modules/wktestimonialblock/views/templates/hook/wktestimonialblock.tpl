{*
* Farmhouse theme override for wktestimonialblock wktestimonialblock.tpl
* Testimonials as static responsive cards (no carousel).
*}

{block name='testimonial_block'}
    {if isset($testimonials_data) && $testimonials_data}
        <div id="hotelTestimonialBlock" class="fh-section fh-home-block">
            {if $HOTEL_TESIMONIAL_BLOCK_HEADING && $HOTEL_TESIMONIAL_BLOCK_CONTENT}
                <div class="fh-container">
                    {block name='testimonial_block_heading'}
                        <h2 class="fh-section-title">{$HOTEL_TESIMONIAL_BLOCK_HEADING|escape:'htmlall':'UTF-8'}</h2>
                    {/block}
                    {block name='testimonial_block_description'}
                        <p class="fh-section-subtitle">{$HOTEL_TESIMONIAL_BLOCK_CONTENT|escape:'htmlall':'UTF-8'}</p>
                    {/block}
                </div>
            {/if}
            {block name='testimonial_block_content'}
                <div class="fh-container fh-testimonial-grid">
                    {foreach $testimonials_data as $tesimonial}
                        <div class="fh-card fh-testimonial-card">
                            <div class="fh-testimonial-card__quote"><svg class="fh-ic" aria-hidden="true"><use href="#fh-ic-quote"/></svg></div>
                            <p class="fh-testimonial-card__text">{$tesimonial.testimonial_content|escape:'htmlall':'UTF-8'}</p>
                            <div class="fh-testimonial-card__person">
                                {if $tesimonial.img_url}
                                    <img width="48" height="48" loading="lazy" src="{$tesimonial.img_url}" class="fh-testimonial-card__img" alt="{$tesimonial.name|escape:'htmlall':'UTF-8'}">
                                {/if}
                                <div>
                                    <p class="fh-testimonial-card__name">{$tesimonial.name|escape:'htmlall':'UTF-8'}</p>
                                    <p class="fh-testimonial-card__desig">{$tesimonial.designation|escape:'htmlall':'UTF-8'}</p>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                </div>
            {/block}
        </div>
    {/if}
{/block}
