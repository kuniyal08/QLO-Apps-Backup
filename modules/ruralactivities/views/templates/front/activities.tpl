<section class="rural-activities-page">
    <header class="rural-activities-page-header">
        <span class="section-kicker">{l s='Things to do' mod='ruralactivities'}</span>
        <h1>{l s='Find local stories around every stay' mod='ruralactivities'}</h1>
        <p>{l s='Browse cultural, craft, food and nature experiences shared by our rural hosts. These are local recommendations, not bookable activities.' mod='ruralactivities'}</p>
    </header>

    <form class="rural-activities-filter" method="get" action="{$activities_url|escape:'html':'UTF-8'}">
        <label for="rural_activity_hotel">{l s='Choose a property' mod='ruralactivities'}</label>
        <select id="rural_activity_hotel" name="id_hotel" onchange="this.form.submit()">
            <option value="0">{l s='All properties' mod='ruralactivities'}</option>
            {foreach from=$rural_activity_properties item=property}
                <option value="{$property.id|intval}"{if $selected_hotel_id == $property.id} selected="selected"{/if}>{$property.hotel_name|escape:'html':'UTF-8'}</option>
            {/foreach}
        </select>
        <noscript><button type="submit" class="btn btn-primary">{l s='Show experiences' mod='ruralactivities'}</button></noscript>
    </form>

    {if $rural_activities}
        <div class="rural-activities-directory-grid">
            {foreach from=$rural_activities item=activity}
                <article class="rural-activity-directory-card">
                    <div class="rural-activity-directory-card-top">
                        {if $activity.category}<span class="rural-activity-category">{$activity.category|escape:'html':'UTF-8'}</span>{/if}
                        <span class="rural-activity-property"><i class="icon-map-marker" aria-hidden="true"></i>{$activity.hotel_name|escape:'html':'UTF-8'}</span>
                    </div>
                    <h2>{$activity.name|escape:'html':'UTF-8'}</h2>
                    <p>{$activity.short_description|escape:'html':'UTF-8'}</p>
                    {if $activity.typical_duration || $activity.season_notes}
                        <div class="rural-activity-directory-meta">
                            {if $activity.typical_duration}<span><i class="icon-time" aria-hidden="true"></i>{$activity.typical_duration|escape:'html':'UTF-8'}</span>{/if}
                            {if $activity.season_notes}<span><i class="icon-calendar" aria-hidden="true"></i>{$activity.season_notes|escape:'html':'UTF-8'}</span>{/if}
                        </div>
                    {/if}
                </article>
            {/foreach}
        </div>

        {if $page_count > 1}
            <nav class="rural-activities-pagination" aria-label="{l s='Activities pages' mod='ruralactivities'}">
                {if $current_page > 1}<a class="btn btn-default" href="{$activities_url|escape:'html':'UTF-8'}?id_hotel={$selected_hotel_id|intval}&amp;page={$current_page-1|intval}">{l s='Previous' mod='ruralactivities'}</a>{/if}
                <span>{l s='Page' mod='ruralactivities'} {$current_page|intval} {l s='of' mod='ruralactivities'} {$page_count|intval}</span>
                {if $current_page < $page_count}<a class="btn btn-default" href="{$activities_url|escape:'html':'UTF-8'}?id_hotel={$selected_hotel_id|intval}&amp;page={$current_page+1|intval}">{l s='Next' mod='ruralactivities'}</a>{/if}
            </nav>
        {/if}
    {else}
        <div class="rural-activities-empty">
            <h2>{l s='More local experiences are coming soon' mod='ruralactivities'}</h2>
            <p>{l s='Choose another property or check back as hosts share their local recommendations.' mod='ruralactivities'}</p>
        </div>
    {/if}
</section>
