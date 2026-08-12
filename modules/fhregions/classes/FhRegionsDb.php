<?php
/**
 * Database installation helper for Fhregions.
 *
 * @license OSL-3.0
 */

/**
 * Creates the module's informational discovery tables.
 */
class FhRegionsDb
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
            'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'fhdiscover_region` (
                `id_region` int(10) unsigned NOT NULL AUTO_INCREMENT,
                `active` tinyint(1) unsigned NOT NULL DEFAULT 1,
                `position` int(10) unsigned NOT NULL DEFAULT 0,
                `cover` varchar(255) NOT NULL DEFAULT \'\',
                `date_add` datetime NOT NULL,
                `date_upd` datetime NOT NULL,
                PRIMARY KEY (`id_region`),
                KEY `fhdiscover_region_active` (`active`, `position`)
            ) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;',
            'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'fhdiscover_region_lang` (
                `id_region` int(10) unsigned NOT NULL,
                `id_lang` int(10) unsigned NOT NULL,
                `name` varchar(255) NOT NULL,
                `blurb` text NOT NULL,
                `description` text NOT NULL,
                PRIMARY KEY (`id_region`, `id_lang`)
            ) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;',
            'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'fhdiscover_region_hotel` (
                `id_region` int(10) unsigned NOT NULL,
                `id_hotel` int(10) unsigned NOT NULL,
                PRIMARY KEY (`id_region`, `id_hotel`),
                KEY `fhdiscover_region_hotel_hotel` (`id_hotel`)
            ) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;',
            'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'fhdiscover_region_activity` (
                `id_region` int(10) unsigned NOT NULL,
                `id_rural_activity` int(10) unsigned NOT NULL,
                PRIMARY KEY (`id_region`, `id_rural_activity`),
                KEY `fhdiscover_region_activity_activity` (`id_rural_activity`)
            ) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;',
        );
    }
}