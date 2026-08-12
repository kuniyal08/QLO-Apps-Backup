<?php
/**
 * Informational blog category model.
 *
 * @license OSL-3.0
 */

/**
 * Represents a translatable category grouping blog posts.
 */
class FhBlogCategory extends ObjectModel
{
    /** @var int */
    public $position;
    /** @var bool */
    public $active;
    /** @var string */
    public $name;

    /** @var array */
    public static $definition = array(
        'table' => 'fhdiscover_blog_category',
        'primary' => 'id_blog_category',
        'multilang' => true,
        'fields' => array(
            'position' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'active' => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
            'name' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isGenericName', 'required' => true, 'size' => 255),
        ),
    );

    /**
     * Get the active categories for the filter bar and admin selects.
     *
     * @param int $idLang Language ID.
     *
     * @return array
     */
    public static function getList($idLang)
    {
        $idLang = (int) $idLang;
        if (!Validate::isUnsignedId($idLang)) {
            return array();
        }

        $categories = Db::getInstance()->executeS(
            'SELECT c.`id_blog_category`, c.`position`, cl.`name`,
                (SELECT COUNT(*) FROM `'._DB_PREFIX_.'fhdiscover_blog_post` p
                    WHERE p.`id_blog_category` = c.`id_blog_category` AND p.`active` = 1) AS post_count
            FROM `'._DB_PREFIX_.'fhdiscover_blog_category` c
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_blog_category_lang` cl
                ON cl.`id_blog_category` = c.`id_blog_category` AND cl.`id_lang` = '.$idLang.'
            WHERE c.`active` = 1
            ORDER BY c.`position` ASC, c.`id_blog_category` ASC'
        );

        return $categories;
    }
}