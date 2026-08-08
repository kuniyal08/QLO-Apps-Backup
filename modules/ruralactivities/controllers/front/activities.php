<?php
/**
 * Public local experiences listing controller.
 *
 * @license AFL-3.0
 */

/**
 * Displays informational activities without exposing booking operations.
 */
class RuralactivitiesActivitiesModuleFrontController extends ModuleFrontController
{
    /** @var int */
    private $perPage = 12;

    /**
     * Load the module's responsive activity directory styles.
     */
    public function setMedia()
    {
        parent::setMedia();
        $this->addCSS($this->module->getPathUri().'views/css/ruralactivities.css');
    }

    /**
     * Prepare paginated activity discovery content.
     */
    public function initContent()
    {
        parent::initContent();

        $idHotel = (int) Tools::getValue('id_hotel');
        $page = max(1, (int) Tools::getValue('page', 1));
        if ($idHotel && !Validate::isUnsignedId($idHotel)) {
            $idHotel = 0;
        }

        $total = RuralActivity::countActive($idHotel);
        $pageCount = max(1, (int) ceil($total / $this->perPage));
        $page = min($page, $pageCount);
        $idLang = (int) $this->context->language->id;
        $properties = HotelBranchInformation::hotelBranchesInfo($idLang, 1, 0);

        $this->context->smarty->assign(array(
            'rural_activities' => RuralActivity::getPage($idLang, $idHotel, $page, $this->perPage),
            'rural_activity_properties' => $properties,
            'selected_hotel_id' => $idHotel,
            'current_page' => $page,
            'page_count' => $pageCount,
            'activities_url' => $this->context->link->getModuleLink($this->module->name, 'activities'),
        ));
        $this->setTemplate('activities.tpl');
    }
}
