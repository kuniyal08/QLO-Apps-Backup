<?php
/**
 * Informational blog post model.
 *
 * @license OSL-3.0
 */

/**
 * Represents a translatable editorial post with a category and cover image.
 */
class FhBlogPost extends ObjectModel
{
    /** @var int */
    public $id_blog_category;
    /** @var string */
    public $cover;
    /** @var bool */
    public $active;
    /** @var string */
    public $date_add;
    /** @var string */
    public $date_upd;
    /** @var string */
    public $title;
    /** @var string */
    public $slug;
    /** @var string */
    public $excerpt;
    /** @var string */
    public $content;
    /** @var string */
    public $author;
    /** @var string */
    public $meta_title;
    /** @var string */
    public $meta_description;

    /** @var array */
    public static $definition = array(
        'table' => 'fhdiscover_blog_post',
        'primary' => 'id_blog_post',
        'multilang' => true,
        'fields' => array(
            'id_blog_category' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true),
            'cover' => array('type' => self::TYPE_STRING, 'validate' => 'isFileName', 'size' => 255),
            'active' => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
            'date_add' => array('type' => self::TYPE_DATE, 'validate' => 'isDate'),
            'date_upd' => array('type' => self::TYPE_DATE, 'validate' => 'isDate'),
            'title' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isGenericName', 'required' => true, 'size' => 255),
            'slug' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isLinkRewrite', 'required' => true, 'size' => 255),
            'excerpt' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isCleanHtml', 'required' => true),
            'content' => array('type' => self::TYPE_HTML, 'lang' => true, 'validate' => 'isCleanHtml'),
            'author' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isGenericName', 'size' => 255),
            'meta_title' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isGenericName', 'size' => 255),
            'meta_description' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isGenericName', 'size' => 255),
        ),
    );

    /**
     * Get the most recent active posts.
     *
     * @param int $idLang Language ID.
     * @param int $limit Maximum records to return.
     *
     * @return array
     */
    public static function getLatest($idLang, $limit = 3)
    {
        $limit = min(12, max(1, (int) $limit));

        return self::getPage($idLang, 0, 1, $limit);
    }

    /**
     * Get a paginated public post listing, optionally filtered by category.
     *
     * @param int $idLang Language ID.
     * @param int $idCategory Optional category ID.
     * @param int $page One-indexed page number.
     * @param int $perPage Maximum records to return.
     *
     * @return array
     */
    public static function getPage($idLang, $idCategory = 0, $page = 1, $perPage = 9)
    {
        $idLang = (int) $idLang;
        $idCategory = (int) $idCategory;
        $page = max(1, (int) $page);
        $perPage = min(50, max(1, (int) $perPage));
        $offset = ($page - 1) * $perPage;

        if (!Validate::isUnsignedId($idLang) || ($idCategory && !Validate::isUnsignedId($idCategory))) {
            return array();
        }

        return Db::getInstance()->executeS(
            'SELECT p.`id_blog_post`, p.`id_blog_category`, p.`cover`, p.`date_add`,
                pl.`title`, pl.`slug`, pl.`excerpt`, pl.`author`, cl.`name` AS category_name
            FROM `'._DB_PREFIX_.'fhdiscover_blog_post` p
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_blog_post_lang` pl
                ON pl.`id_blog_post` = p.`id_blog_post` AND pl.`id_lang` = '.$idLang.'
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_blog_category` c
                ON c.`id_blog_category` = p.`id_blog_category` AND c.`active` = 1
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_blog_category_lang` cl
                ON cl.`id_blog_category` = p.`id_blog_category` AND cl.`id_lang` = '.$idLang.'
            WHERE p.`active` = 1'.($idCategory ? ' AND p.`id_blog_category` = '.$idCategory : '').'
            ORDER BY p.`date_add` DESC, p.`id_blog_post` DESC
            LIMIT '.$offset.', '.$perPage
        );
    }

    /**
     * Count active posts, optionally for one category.
     *
     * @param int $idCategory Optional category ID.
     *
     * @return int
     */
    public static function countActive($idCategory = 0)
    {
        $idCategory = (int) $idCategory;
        if ($idCategory && !Validate::isUnsignedId($idCategory)) {
            return 0;
        }

        return (int) Db::getInstance()->getValue(
            'SELECT COUNT(*)
            FROM `'._DB_PREFIX_.'fhdiscover_blog_post` p
            WHERE p.`active` = 1'.($idCategory ? ' AND p.`id_blog_category` = '.$idCategory : '')
        );
    }

    /**
     * Get posts related by category to a given post.
     *
     * @param int $idLang Language ID.
     * @param int $idPost Source post ID.
     * @param int $limit Maximum records to return.
     *
     * @return array
     */
    public static function getRelated($idLang, $idPost, $limit = 3)
    {
        $idPost = (int) $idPost;
        $limit = min(6, max(1, (int) $limit));

        if (!Validate::isUnsignedId($idLang) || !Validate::isUnsignedId($idPost)) {
            return array();
        }

        return Db::getInstance()->executeS(
            'SELECT p.`id_blog_post`, p.`id_blog_category`, p.`cover`, p.`date_add`,
                pl.`title`, pl.`slug`, pl.`excerpt`, pl.`author`, cl.`name` AS category_name
            FROM `'._DB_PREFIX_.'fhdiscover_blog_post` p
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_blog_post_lang` pl
                ON pl.`id_blog_post` = p.`id_blog_post` AND pl.`id_lang` = '.$idLang.'
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_blog_category_lang` cl
                ON cl.`id_blog_category` = p.`id_blog_category` AND cl.`id_lang` = '.$idLang.'
            WHERE p.`active` = 1 AND p.`id_blog_post` <> '.$idPost.'
                AND p.`id_blog_category` = (SELECT `id_blog_category` FROM `'._DB_PREFIX_.'fhdiscover_blog_post` WHERE `id_blog_post` = '.$idPost.')
            ORDER BY p.`date_add` DESC, p.`id_blog_post` DESC
            LIMIT '.$limit
        );
    }

    /**
     * Get the adjacent posts for prev/next navigation by publish date.
     *
     * @param int $idLang Language ID.
     * @param int $idPost Current post ID.
     * @param string $dateAdd Current post publish date.
     *
     * @return array
     */
    public static function getAdjacent($idLang, $idPost, $dateAdd)
    {
        $db = Db::getInstance();

        $prev = $db->getRow(
            'SELECT p.`id_blog_post`, pl.`title`
            FROM `'._DB_PREFIX_.'fhdiscover_blog_post` p
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_blog_post_lang` pl
                ON pl.`id_blog_post` = p.`id_blog_post` AND pl.`id_lang` = '.(int) $idLang.'
            WHERE p.`active` = 1 AND (p.`date_add` < \''.pSQL($dateAdd).'\'
                OR (p.`date_add` = \''.pSQL($dateAdd).'\' AND p.`id_blog_post` < '.(int) $idPost.'))
            ORDER BY p.`date_add` DESC, p.`id_blog_post` DESC'
        );

        $next = $db->getRow(
            'SELECT p.`id_blog_post`, pl.`title`
            FROM `'._DB_PREFIX_.'fhdiscover_blog_post` p
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_blog_post_lang` pl
                ON pl.`id_blog_post` = p.`id_blog_post` AND pl.`id_lang` = '.(int) $idLang.'
            WHERE p.`active` = 1 AND (p.`date_add` > \''.pSQL($dateAdd).'\'
                OR (p.`date_add` = \''.pSQL($dateAdd).'\' AND p.`id_blog_post` > '.(int) $idPost.'))
            ORDER BY p.`date_add` ASC, p.`id_blog_post` ASC'
        );

        return array('prev' => $prev, 'next' => $next);
    }
}