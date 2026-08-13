<?php
/**
 * Informational region model.
 *
 * @license OSL-3.0
 */

/**
 * Represents a translatable UP region used for farmstay and activity discovery.
 */
class FhRegion extends ObjectModel
{
    /** @var bool */
    public $active;
    /** @var int */
    public $position;
    /** @var string */
    public $cover;
    /** @var string */
    public $date_add;
    /** @var string */
    public $date_upd;
    /** @var string */
    public $name;
    /** @var string */
    public $blurb;
    /** @var string */
    public $description;

    /** @var array */
    public static $definition = array(
        'table' => 'fhdiscover_region',
        'primary' => 'id_region',
        'multilang' => true,
        'fields' => array(
            'active' => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
            'position' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'cover' => array('type' => self::TYPE_STRING, 'validate' => 'isFileName', 'size' => 255),
            'date_add' => array('type' => self::TYPE_DATE, 'validate' => 'isDate'),
            'date_upd' => array('type' => self::TYPE_DATE, 'validate' => 'isDate'),
            'name' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isGenericName', 'required' => true, 'size' => 255),
            'blurb' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isCleanHtml', 'required' => true),
            'description' => array('type' => self::TYPE_HTML, 'lang' => true, 'validate' => 'isCleanHtml'),
        ),
    );

    /**
     * Get the full link table rows for one region.
     *
     * @param int $idRegion Region ID.
     * @param string $table Link table name.
     * @param string $column Link column name.
     *
     * @return array
     */
    private static function getLinks($idRegion, $table, $column)
    {
        return Db::getInstance()->executeS(
            'SELECT `'.$column.'`
            FROM `'._DB_PREFIX_.bqSQL($table).'`
            WHERE `id_region` = '.(int) $idRegion.'
            ORDER BY `'.$column.'` ASC'
        );
    }

    /**
     * Get the property IDs linked to a region.
     *
     * @param int $idRegion Region ID.
     *
     * @return array
     */
    public static function getHotelIds($idRegion)
    {
        $rows = self::getLinks($idRegion, 'fhdiscover_region_hotel', 'id_hotel');
        $ids = array();
        foreach ($rows as $row) {
            $ids[] = (int) $row['id_hotel'];
        }

        return $ids;
    }

    /**
     * Get the activity IDs linked to a region.
     *
     * @param int $idRegion Region ID.
     *
     * @return array
     */
    public static function getActivityIds($idRegion)
    {
        $rows = self::getLinks($idRegion, 'fhdiscover_region_activity', 'id_rural_activity');
        $ids = array();
        foreach ($rows as $row) {
            $ids[] = (int) $row['id_rural_activity'];
        }

        return $ids;
    }

    /**
     * Replace the property links of a region.
     *
     * @param int $idRegion Region ID.
     * @param array $ids Property IDs.
     *
     * @return bool
     */
    public static function setHotelIds($idRegion, array $ids)
    {
        return self::setLinks($idRegion, 'fhdiscover_region_hotel', 'id_hotel', $ids);
    }

    /**
     * Replace the activity links of a region.
     *
     * @param int $idRegion Region ID.
     * @param array $ids Activity IDs.
     *
     * @return bool
     */
    public static function setActivityIds($idRegion, array $ids)
    {
        return self::setLinks($idRegion, 'fhdiscover_region_activity', 'id_rural_activity', $ids);
    }

    /**
     * Replace the link rows of one region on one link table.
     *
     * @param int $idRegion Region ID.
     * @param string $table Link table name.
     * @param string $column Link column name.
     * @param array $ids Values to set.
     *
     * @return bool
     */
    private static function setLinks($idRegion, $table, $column, array $ids)
    {
        $db = Db::getInstance();
        if (!$db->execute('DELETE FROM `'._DB_PREFIX_.bqSQL($table).'` WHERE `id_region` = '.(int) $idRegion)) {
            return false;
        }

        $ids = array_unique(array_map('intval', $ids));
        foreach ($ids as $id) {
            if (!Validate::isUnsignedId($id)) {
                continue;
            }
            if (!$db->insert($table, array('id_region' => (int) $idRegion, $column => $id))) {
                return false;
            }
        }

        return true;
    }

    /**
     * Get active regions for the homepage preview strip.
     *
     * @param int $idLang Language ID.
     * @param int $limit Maximum records to return.
     *
     * @return array
     */
    public static function getForHome($idLang, $limit = 6)
    {
        $idLang = (int) $idLang;
        $limit = min(12, max(1, (int) $limit));

        if (!Validate::isUnsignedId($idLang)) {
            return array();
        }

        $sql = 'SELECT fr.`id_region`, fr.`position`, fr.`cover`, frl.`name`, frl.`blurb`,
                (SELECT COUNT(*) FROM `'._DB_PREFIX_.'fhdiscover_region_hotel` frh
                    INNER JOIN `'._DB_PREFIX_.'htl_branch_info` hb ON hb.`id` = frh.`id_hotel` AND hb.`active` = 1
                    WHERE frh.`id_region` = fr.`id_region`) AS hotel_count,
                (SELECT COUNT(*) FROM `'._DB_PREFIX_.'fhdiscover_region_activity` fra
                    INNER JOIN `'._DB_PREFIX_.'rural_activity` ra2 ON ra2.`id_rural_activity` = fra.`id_rural_activity` AND ra2.`active` = 1
                    WHERE fra.`id_region` = fr.`id_region`) AS activity_count
            FROM `'._DB_PREFIX_.'fhdiscover_region` fr
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_region_lang` frl
                ON frl.`id_region` = fr.`id_region` AND frl.`id_lang` = '.$idLang.'
            WHERE fr.`active` = 1
            ORDER BY fr.`position` ASC, fr.`id_region` ASC
            LIMIT '.$limit;

        return Db::getInstance()->executeS($sql);
    }

    /**
     * Get a paginated public region listing with discovery counts.
     *
     * @param int $idLang Language ID.
     * @param int $page One-indexed page number.
     * @param int $perPage Maximum records to return.
     *
     * @return array
     */
    public static function getPage($idLang, $page = 1, $perPage = 12)
    {
        $idLang = (int) $idLang;
        $page = max(1, (int) $page);
        $perPage = min(50, max(1, (int) $perPage));
        $offset = ($page - 1) * $perPage;

        if (!Validate::isUnsignedId($idLang)) {
            return array();
        }

        $sql = 'SELECT fr.`id_region`, fr.`position`, fr.`cover`, frl.`name`, frl.`blurb`, frl.`description`,
                (SELECT COUNT(*) FROM `'._DB_PREFIX_.'fhdiscover_region_hotel` frh
                    INNER JOIN `'._DB_PREFIX_.'htl_branch_info` hb ON hb.`id` = frh.`id_hotel` AND hb.`active` = 1
                    WHERE frh.`id_region` = fr.`id_region`) AS hotel_count,
                (SELECT COUNT(*) FROM `'._DB_PREFIX_.'fhdiscover_region_activity` fra
                    INNER JOIN `'._DB_PREFIX_.'rural_activity` ra2 ON ra2.`id_rural_activity` = fra.`id_rural_activity` AND ra2.`active` = 1
                    WHERE fra.`id_region` = fr.`id_region`) AS activity_count
            FROM `'._DB_PREFIX_.'fhdiscover_region` fr
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_region_lang` frl
                ON frl.`id_region` = fr.`id_region` AND frl.`id_lang` = '.$idLang.'
            WHERE fr.`active` = 1
            ORDER BY fr.`position` ASC, fr.`id_region` ASC
            LIMIT '.$offset.', '.$perPage;

        return Db::getInstance()->executeS($sql);
    }

    /**
     * Count active regions for pagination.
     *
     * @return int
     */
    public static function countActive()
    {
        return (int) Db::getInstance()->getValue(
            'SELECT COUNT(*) FROM `'._DB_PREFIX_.'fhdiscover_region` WHERE `active` = 1'
        );
    }

    /**
     * Get the active properties linked to a region.
     *
     * @param int $idRegion Region ID.
     * @param int $idLang Language ID.
     *
     * @return array
     */
    public static function getHotels($idRegion, $idLang)
    {
        $ids = self::getHotelIds($idRegion);
        if (!$ids) {
            return array();
        }

        return Db::getInstance()->executeS(
            'SELECT hb.`id`, hb.`id_category`, hbl.`hotel_name`, hbl.`short_description`, hb.`rating`,
                hi.`id` AS `id_cover_img`, a.`city`
            FROM `'._DB_PREFIX_.'htl_branch_info` hb
            INNER JOIN `'._DB_PREFIX_.'htl_branch_info_lang` hbl
                ON hbl.`id` = hb.`id` AND hbl.`id_lang` = '.(int) $idLang.'
            LEFT JOIN `'._DB_PREFIX_.'htl_image` hi ON hi.`id_hotel` = hb.`id` AND hi.`cover` = 1
            LEFT JOIN `'._DB_PREFIX_.'address` a ON a.`id_hotel` = hb.`id` AND a.`deleted` = 0
            WHERE hb.`active` = 1 AND hb.`id` IN ('.implode(',', $ids).')
            ORDER BY hb.`id` ASC'
        );
    }

    /**
     * Get the informational activities linked to a region.
     *
     * @param int $idRegion Region ID.
     * @param int $idLang Language ID.
     * @param int $limit Maximum records to return.
     *
     * @return array
     */
    public static function getActivities($idRegion, $idLang, $limit = 12)
    {
        $ids = self::getActivityIds($idRegion);
        if (!$ids) {
            return array();
        }

        $limit = min(50, max(1, (int) $limit));

        return Db::getInstance()->executeS(
            'SELECT ra.`id_rural_activity`, ra.`id_hotel`, ra.`position`,
                ral.`name`, ral.`category`, ral.`typical_duration`, ral.`season_notes`,
                ral.`short_description`, hbl.`hotel_name`
            FROM `'._DB_PREFIX_.'rural_activity` ra
            INNER JOIN `'._DB_PREFIX_.'rural_activity_lang` ral
                ON ral.`id_rural_activity` = ra.`id_rural_activity`
                AND ral.`id_lang` = '.(int) $idLang.'
            INNER JOIN `'._DB_PREFIX_.'htl_branch_info` hb
                ON hb.`id` = ra.`id_hotel` AND hb.`active` = 1
            INNER JOIN `'._DB_PREFIX_.'htl_branch_info_lang` hbl
                ON hbl.`id` = ra.`id_hotel` AND hbl.`id_lang` = '.(int) $idLang.'
            WHERE ra.`active` = 1 AND ra.`id_rural_activity` IN ('.implode(',', $ids).')
            ORDER BY ra.`position` ASC, ra.`id_rural_activity` ASC
            LIMIT '.$limit
        );
    }

    /**
     * Get the regions a property belongs to.
     *
     * @param int $idHotel Property ID.
     * @param int $idLang Language ID.
     *
     * @return array
     */
    public static function getByHotel($idHotel, $idLang)
    {
        return Db::getInstance()->executeS(
            'SELECT fr.`id_region`, fr.`position`, fr.`cover`, frl.`name`, frl.`blurb`
            FROM `'._DB_PREFIX_.'fhdiscover_region` fr
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_region_lang` frl
                ON frl.`id_region` = fr.`id_region` AND frl.`id_lang` = '.(int) $idLang.'
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_region_hotel` frh
                ON frh.`id_region` = fr.`id_region` AND frh.`id_hotel` = '.(int) $idHotel.'
            WHERE fr.`active` = 1
            ORDER BY fr.`position` ASC, fr.`id_region` ASC'
        );
    }

    /**
     * Get adjacent active regions for prev/next navigation.
     *
     * @param int $idRegion Current region ID.
     * @param int $position Current region position.
     * @param int $idLang Language ID.
     *
     * @return array
     */
    public static function getAdjacent($idRegion, $position, $idLang)
    {
        $db = Db::getInstance();

        $prev = $db->getRow(
            'SELECT fr.`id_region`, frl.`name`
            FROM `'._DB_PREFIX_.'fhdiscover_region` fr
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_region_lang` frl
                ON frl.`id_region` = fr.`id_region` AND frl.`id_lang` = '.(int) $idLang.'
            WHERE fr.`active` = 1 AND (fr.`position` < '.(int) $position.'
                OR (fr.`position` = '.(int) $position.' AND fr.`id_region` < '.(int) $idRegion.'))
            ORDER BY fr.`position` DESC, fr.`id_region` DESC'
        );

        $next = $db->getRow(
            'SELECT fr.`id_region`, frl.`name`
            FROM `'._DB_PREFIX_.'fhdiscover_region` fr
            INNER JOIN `'._DB_PREFIX_.'fhdiscover_region_lang` frl
                ON frl.`id_region` = fr.`id_region` AND frl.`id_lang` = '.(int) $idLang.'
            WHERE fr.`active` = 1 AND (fr.`position` > '.(int) $position.'
                OR (fr.`position` = '.(int) $position.' AND fr.`id_region` > '.(int) $idRegion.'))
            ORDER BY fr.`position` ASC, fr.`id_region` ASC'
        );

        return array('prev' => $prev, 'next' => $next);
    }
}
