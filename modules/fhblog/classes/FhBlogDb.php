<?php
/**
 * Database installation helper for Fhblog.
 *
 * @license OSL-3.0
 */

/**
 * Creates the module's informational editorial tables.
 */
class FhBlogDb
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
            'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'fhdiscover_blog_category` (
                `id_blog_category` int(10) unsigned NOT NULL AUTO_INCREMENT,
                `position` int(10) unsigned NOT NULL DEFAULT 0,
                `active` tinyint(1) unsigned NOT NULL DEFAULT 1,
                PRIMARY KEY (`id_blog_category`)
            ) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;',
            'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'fhdiscover_blog_category_lang` (
                `id_blog_category` int(10) unsigned NOT NULL,
                `id_lang` int(10) unsigned NOT NULL,
                `name` varchar(255) NOT NULL,
                PRIMARY KEY (`id_blog_category`, `id_lang`)
            ) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;',
            'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'fhdiscover_blog_post` (
                `id_blog_post` int(10) unsigned NOT NULL AUTO_INCREMENT,
                `id_blog_category` int(10) unsigned NOT NULL,
                `cover` varchar(255) NOT NULL DEFAULT \'\',
                `active` tinyint(1) unsigned NOT NULL DEFAULT 1,
                `date_add` datetime NOT NULL,
                `date_upd` datetime NOT NULL,
                PRIMARY KEY (`id_blog_post`),
                KEY `fhdiscover_blog_post_active` (`active`, `date_add`),
                KEY `fhdiscover_blog_post_category` (`id_blog_category`)
            ) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;',
            'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'fhdiscover_blog_post_lang` (
                `id_blog_post` int(10) unsigned NOT NULL,
                `id_lang` int(10) unsigned NOT NULL,
                `title` varchar(255) NOT NULL,
                `slug` varchar(255) NOT NULL,
                `excerpt` text NOT NULL,
                `content` mediumtext NOT NULL,
                `author` varchar(255) NOT NULL,
                `meta_title` varchar(255) NOT NULL,
                `meta_description` varchar(255) NOT NULL,
                PRIMARY KEY (`id_blog_post`, `id_lang`),
                KEY `fhdiscover_blog_post_lang_slug` (`slug`)
            ) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;',
        );
    }
}