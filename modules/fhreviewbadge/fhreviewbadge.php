<?php
/**
 * 2026 Farmhouse Theme
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 *
 * DISCLAIMER
 * Do not edit or add to this file if you wish to upgrade the theme to newer
 * versions in the future.
 *
 * @author Farmhouse Theme
 * @copyright 2026 Farmhouse Theme
 * @license http://opensource.org/licenses/afl-3.0.php Academic Free License (AFL 3.0)
 */

if (!defined('_PS_VERSION_')) {
    exit;
}

class FhReviewBadge extends Module
{
    /** @var string[] Hooks registered by this module */
    const FHRB_HOOKS = array(
        'displayHotelRoomsBlockImageAfter',
        'displayRoomTypeListImageAfter',
        'displayFhHotelRating',
    );

    public function __construct()
    {
        $this->name = 'fhreviewbadge';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Farmhouse Theme';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = array('min' => '1.6', 'max' => '1.9');
        $this->bootstrap = false;

        parent::__construct();

        $this->displayName = $this->l('Farmhouse Review Badges');
        $this->description = $this->l('Shows data-driven guest review ratings on room cards and the booking search panel.');
    }

    public function install()
    {
        if (!parent::install()) {
            return false;
        }

        return $this->registerHook(self::FHRB_HOOKS);
    }

    /**
     * Renders the card rating badge for the home grid.
     *
     * @param array $params hook params (room_type)
     *
     * @return string
     */
    public function hookDisplayHotelRoomsBlockImageAfter($params)
    {
        $idProduct = isset($params['room_type']['id_product']) ? (int) $params['room_type']['id_product'] : 0;
        if (!$idProduct) {
            return '';
        }

        return $this->renderBadge($this->getHotelIdByProduct($idProduct));
    }

    /**
     * Renders the card rating badge for the category listing.
     *
     * @param array $params hook params (product)
     *
     * @return string
     */
    public function hookDisplayRoomTypeListImageAfter($params)
    {
        $idProduct = isset($params['product']['id_product']) ? (int) $params['product']['id_product'] : 0;
        if (!$idProduct) {
            return '';
        }

        return $this->renderBadge($this->getHotelIdByProduct($idProduct));
    }

    /**
     * Renders the rating strip used by search panels via {hook h='displayFhHotelRating' id_hotel=...}.
     *
     * @param array $params hook params (id_hotel)
     *
     * @return string
     */
    public function hookDisplayFhHotelRating($params)
    {
        $idHotel = isset($params['id_hotel']) ? (int) $params['id_hotel'] : 0;
        if (!$idHotel) {
            return '';
        }

        $data = $this->getRatingData($idHotel);

        $this->smarty->assign(array(
            'fh_rating' => $data,
            'fh_rating_percent' => $this->getRatingPercent($data),
        ));

        return $this->display(__FILE__, 'rating-strip.tpl');
    }

    /**
     * Returns the hotel id owning a room type product.
     *
     * @param int $idProduct
     *
     * @return int
     */
    protected function getHotelIdByProduct($idProduct)
    {
        static $hotelByProduct = array();
        if (isset($hotelByProduct[$idProduct])) {
            return $hotelByProduct[$idProduct];
        }

        $roomTypeInfo = (new HotelRoomType())->getRoomTypeInfoByIdProduct($idProduct);
        $hotelByProduct[$idProduct] = isset($roomTypeInfo['id_hotel']) ? (int) $roomTypeInfo['id_hotel'] : 0;

        return $hotelByProduct[$idProduct];
    }

    /**
     * Returns approved guest review aggregates for a hotel.
     *
     * @param int $idHotel
     *
     * @return array|null
     */
    protected function getRatingData($idHotel)
    {
        $idHotel = (int) $idHotel;
        if (!$idHotel) {
            return null;
        }

        static $ratingCache = array();
        if (isset($ratingCache[$idHotel])) {
            return $ratingCache[$idHotel];
        }

        $count = (int) QhrHotelReview::getReviewCountByIdHotel($idHotel);
        $average = QhrHotelReview::getAverageRatingByIdHotel($idHotel);
        $ratingCache[$idHotel] = array(
            'id_hotel' => $idHotel,
            'avg' => $average ? (float) round($average, 1) : 0.0,
            'count' => $count,
        );

        return $ratingCache[$idHotel];
    }

    /**
     * Computes the filled-star width percentage for the overlay row.
     *
     * @param array|null $ratingData
     *
     * @return int
     */
    protected function getRatingPercent($ratingData)
    {
        if (!$ratingData || $ratingData['avg'] <= 0) {
            return 0;
        }

        return (int) round($ratingData['avg'] / 5 * 100);
    }

    /**
     * Renders the card badge only when approved guest reviews exist.
     *
     * @param int $idHotel
     *
     * @return string
     */
    protected function renderBadge($idHotel)
    {
        $data = $this->getRatingData($idHotel);
        if (!$data || $data['count'] <= 0) {
            return '';
        }

        $this->smarty->assign(array(
            'fh_rating' => $data,
            'fh_rating_percent' => $this->getRatingPercent($data),
        ));

        return $this->display(__FILE__, 'rating-badge.tpl');
    }
}
