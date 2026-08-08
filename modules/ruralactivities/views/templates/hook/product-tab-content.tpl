<div id="rural_activities_tab" class="tab-pane rural-activities-panel">
    <div class="rural-activities-heading">
        <span class="section-kicker">{l s='Around this stay' mod='ruralactivities'}</span>
        <h3>{l s='Local experiences to ask about' mod='ruralactivities'}</h3>
        <p>{l s='These experiences are informational only. Please contact the property team for current timing and arrangements.' mod='ruralactivities'}</p>
    </div>
    <div class="rural-activities-grid">
        {foreach from=$rural_activities item=activity}
            <article class="rural-activity-card">
                {if $activity.category}<span class="rural-activity-category">{$activity.category|escape:'html':'UTF-8'}</span>{/if}
                <h4>{$activity.name|escape:'html':'UTF-8'}</h4>
                <p>{$activity.short_description|escape:'html':'UTF-8'}</p>
                {if $activity.typical_duration || $activity.season_notes}
                    <dl class="rural-activity-meta">
                        {if $activity.typical_duration}<div><dt>{l s='Typical duration' mod='ruralactivities'}</dt><dd>{$activity.typical_duration|escape:'html':'UTF-8'}</dd></div>{/if}
                        {if $activity.season_notes}<div><dt>{l s='Timing notes' mod='ruralactivities'}</dt><dd>{$activity.season_notes|escape:'html':'UTF-8'}</dd></div>{/if}
                    </dl>
                {/if}
            </article>
        {/foreach}
    </div>
</div>
