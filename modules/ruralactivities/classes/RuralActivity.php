<?php
/**
 * Informational activity model.
 *
 * @license AFL-3.0
 */

/**
 * Represents a translatable local activity associated with one property.
 */
class RuralActivity extends ObjectModel
{
    /** @var int */
    public $id_hotel;
    /** @var bool */
    public $active;
    /** @var int */
    public $position;
    /** @var string */
    public $date_add;
    /** @var string */
    public $date_upd;
    /** @var string */
    public $name;
    /** @var string */
    public $category;
    /** @var string */
    public $typical_duration;
    /** @var string */
    public $season_notes;
    /** @var string */
    public $short_description;
    /** @var string */
    public $description;

    /** @var array */
    public static $definition = array(
        'table' => 'rural_activity',
        'primary' => 'id_rural_activity',
        'multilang' => true,
        'fields' => array(
            'id_hotel' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true),
            'active' => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
            'position' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'date_add' => array('type' => self::TYPE_DATE, 'validate' => 'isDate'),
            'date_upd' => array('type' => self::TYPE_DATE, 'validate' => 'isDate'),
            'name' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isGenericName', 'required' => true, 'size' => 255),
            'category' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isGenericName', 'size' => 128),
            'typical_duration' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isGenericName', 'size' => 128),
            'season_notes' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isGenericName', 'size' => 255),
            'short_description' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isCleanHtml', 'required' => true),
            'description' => array('type' => self::TYPE_HTML, 'lang' => true, 'validate' => 'isCleanHtml'),
        ),
    );

    /**
     * Get active editorial activities for a property and language.
     *
     * @param int $idHotel Property ID.
     * @param int $idLang Language ID.
     * @param int $page One-indexed page number.
     * @param int $perPage Maximum records to return.
     *
     * @return array
     */
    public static function getByHotel($idHotel, $idLang, $page = 1, $perPage = 12)
    {
        $idHotel = (int) $idHotel;
        $idLang = (int) $idLang;
        $page = max(1, (int) $page);
        $perPage = min(50, max(1, (int) $perPage));
        $offset = ($page - 1) * $perPage;

        if (!Validate::isUnsignedId($idHotel) || !Validate::isUnsignedId($idLang)) {
            return array();
        }

        return Db::getInstance()->executeS(
            'SELECT ra.*, ral.`name`, ral.`category`, ral.`typical_duration`, ral.`season_notes`,
                ral.`short_description`, ral.`description`
            FROM `'._DB_PREFIX_.'rural_activity` ra
            INNER JOIN `'._DB_PREFIX_.'rural_activity_lang` ral
                ON ral.`id_rural_activity` = ra.`id_rural_activity`
                AND ral.`id_lang` = '.$idLang.'
            WHERE ra.`id_hotel` = '.$idHotel.' AND ra.`active` = 1
            ORDER BY ra.`position` ASC, ra.`id_rural_activity` DESC
            LIMIT '.$offset.', '.$perPage
        );
    }

    /**
     * Get a paginated public activity listing, optionally for one property.
     *
     * @param int $idLang Language ID.
     * @param int $idHotel Optional property ID.
     * @param int $page One-indexed page number.
     * @param int $perPage Maximum records to return.
     *
     * @return array
     */
    public static function getPage($idLang, $idHotel = 0, $page = 1, $perPage = 12)
    {
        $idLang = (int) $idLang;
        $idHotel = (int) $idHotel;
        $page = max(1, (int) $page);
        $perPage = min(50, max(1, (int) $perPage));
        $offset = ($page - 1) * $perPage;

        if (!Validate::isUnsignedId($idLang) || ($idHotel && !Validate::isUnsignedId($idHotel))) {
            return array();
        }

        return Db::getInstance()->executeS(
            'SELECT ra.*, ral.`name`, ral.`category`, ral.`typical_duration`, ral.`season_notes`,
                ral.`short_description`, hbl.`hotel_name`
            FROM `'._DB_PREFIX_.'rural_activity` ra
            INNER JOIN `'._DB_PREFIX_.'rural_activity_lang` ral
                ON ral.`id_rural_activity` = ra.`id_rural_activity`
                AND ral.`id_lang` = '.$idLang.'
            INNER JOIN `'._DB_PREFIX_.'htl_branch_info` hb
                ON hb.`id` = ra.`id_hotel` AND hb.`active` = 1
            INNER JOIN `'._DB_PREFIX_.'htl_branch_info_lang` hbl
                ON hbl.`id` = ra.`id_hotel` AND hbl.`id_lang` = '.$idLang.'
            WHERE ra.`active` = 1'.($idHotel ? ' AND ra.`id_hotel` = '.$idHotel : '').'
            ORDER BY ra.`position` ASC, ra.`id_rural_activity` DESC
            LIMIT '.$offset.', '.$perPage
        );
    }

    /**
     * Count public activities for pagination.
     *
     * @param int $idHotel Optional property ID.
     *
     * @return int
     */
    public static function countActive($idHotel = 0)
    {
        $idHotel = (int) $idHotel;
        if ($idHotel && !Validate::isUnsignedId($idHotel)) {
            return 0;
        }

        return (int) Db::getInstance()->getValue(
            'SELECT COUNT(*)
            FROM `'._DB_PREFIX_.'rural_activity` ra
            INNER JOIN `'._DB_PREFIX_.'htl_branch_info` hb
                ON hb.`id` = ra.`id_hotel` AND hb.`active` = 1
            WHERE ra.`active` = 1'.($idHotel ? ' AND ra.`id_hotel` = '.$idHotel : '')
        );
    }
}
