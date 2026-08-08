<?php
/**
 * Database installation helper for Ruralactivities.
 *
 * @license AFL-3.0
 */

/**
 * Creates the module's non-booking editorial tables.
 */
class RuralActivitiesDb
{
    /**
     * Create module tables when they do not already exist.
     *
     * @return bool
     */
    public function createTables()
    {
        foreach ($this->getCreateQueries() as $query) {
            if (!Db::getInstance()->execute($query)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Get the table creation statements.
     *
     * @return array
     */
    private function getCreateQueries()
    {
        return array(
            'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'rural_activity` (
                `id_rural_activity` int(10) unsigned NOT NULL AUTO_INCREMENT,
                `id_hotel` int(10) unsigned NOT NULL,
                `active` tinyint(1) unsigned NOT NULL DEFAULT 1,
                `position` int(10) unsigned NOT NULL DEFAULT 0,
                `date_add` datetime NOT NULL,
                `date_upd` datetime NOT NULL,
                PRIMARY KEY (`id_rural_activity`),
                KEY `rural_activity_hotel_active` (`id_hotel`, `active`, `position`)
            ) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;',
            'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'rural_activity_lang` (
                `id_rural_activity` int(10) unsigned NOT NULL,
                `id_lang` int(10) unsigned NOT NULL,
                `name` varchar(255) NOT NULL,
                `category` varchar(128) NOT NULL,
                `typical_duration` varchar(128) NOT NULL,
                `season_notes` varchar(255) NOT NULL,
                `short_description` text NOT NULL,
                `description` text NOT NULL,
                PRIMARY KEY (`id_rural_activity`, `id_lang`)
            ) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;',
        );
    }
}
