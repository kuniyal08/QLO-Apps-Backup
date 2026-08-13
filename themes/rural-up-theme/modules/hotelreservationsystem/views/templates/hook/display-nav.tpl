{if $email != ''}
    <div class="contact-item"><svg class="ru-svg-icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-mail"></use></svg><a href="mailto:{$email|escape:'html':'UTF-8'}">{$email|escape:'html':'UTF-8'}</a></div>
{/if}
{if $phone != ''}
    <div class="contact-item"><svg class="ru-svg-icon" aria-hidden="true"><use href="{$img_dir}rural-up-icons.svg#ru-icon-phone"></use></svg><a href="tel:{$phone|escape:'html':'UTF-8'}">{$phone|escape:'html':'UTF-8'}</a></div>
{/if}
