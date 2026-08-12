<?php
/**
 * Public region detail controller.
 *
 * @license OSL-3.0
 */

/**
 * Displays one region with its linked farmstays and activities.
 */
class FhregionsRegiondetailModuleFrontController extends ModuleFrontController
{
    /**
     * Prepare the region detail content.
     */
    public function initContent()
    {
        parent::initContent();

        $idRegion = (int) Tools::getValue('id_region');
        if (!Validate::isUnsignedId($idRegion)) {
            Tools::redirect($this->context->link->getModuleLink($this->module->name, 'region'));
        }

        $idLang = (int) $this->context->language->id;
        $region = new FhRegion($idRegion, $idLang);
        if (!Validate::isLoadedObject($region) || !$region->active) {
            Tools::redirect($this->context->link->getModuleLink($this->module->name, 'region'));
        }

        $hotels = FhRegion::getHotels($idRegion, $idLang);
        $hotelIds = FhRegion::getHotelIds($idRegion);
        $activities = FhRegion::getActivities($idRegion, $idLang, 12);
        $adjacent = FhRegion::getAdjacent($idRegion, (int) $region->position, $idLang);

        $propertiesUrl = $this->context->link->getPageLink('our-properties');
        $activitiesUrl = Module::isEnabled('ruralactivities')
            ? $this->context->link->getModuleLink('ruralactivities', 'activities')
            : '';

        $this->context->smarty->assign(array(
            'fh_region' => $region,
            'fh_region_hotels' => $hotels,
            'fh_region_hotel_ids' => $hotelIds,
            'fh_region_activities' => $activities,
            'fh_region_adjacent' => $adjacent,
            'fh_properties_url' => $propertiesUrl,
            'fh_activities_url' => $activitiesUrl,
            'fh_region_list_url' => $this->context->link->getModuleLink($this->module->name, 'region'),
            'fh_region_detail_url' => $this->context->link->getModuleLink($this->module->name, 'regiondetail'),
            'meta_title' => $region->name,
        ));

        $this->setTemplate('region-detail.tpl');
    }

    /**
     * Set the page title.
     *
     * @return bool
     */
    public function canonicalRedirection($canonical_url = '')
    {
        return false;
    }

    /**
     * Load module styles on the detail page.
     */
    public function setMedia()
    {
        parent::setMedia();
        $this->addCSS($this->module->getPathUri().'views/css/fhregions.css');
    }
}