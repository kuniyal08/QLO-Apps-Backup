<?php
/**
 * Public region directory controller.
 *
 * @license OSL-3.0
 */

/**
 * Displays informational UP regions without exposing booking operations.
 */
class FhregionsRegionModuleFrontController extends ModuleFrontController
{
    /** @var int */
    private $perPage = 12;

    /**
     * Prepare paginated region discovery content.
     */
    public function initContent()
    {
        parent::initContent();

        $page = max(1, (int) Tools::getValue('page', 1));
        $idLang = (int) $this->context->language->id;

        $total = FhRegion::countActive();
        $pageCount = max(1, (int) ceil($total / $this->perPage));
        $page = min($page, $pageCount);

        $regions = FhRegion::getPage($idLang, $page, $this->perPage);
        $detailUrl = $this->context->link->getModuleLink($this->module->name, 'regiondetail');

        $this->context->smarty->assign(array(
            'fh_regions' => $regions,
            'fh_region_detail_url' => $detailUrl,
            'fh_regions_page' => $page,
            'fh_regions_page_count' => $pageCount,
            'fh_regions_url' => $this->context->link->getModuleLink($this->module->name, 'region'),
        ));

        $this->setTemplate('region.tpl');
    }

    /**
     * Set the page title and canonical meta.
     */
    public function canonicalRedirection($canonical_url = '')
    {
        return false;
    }

    /**
     * Load module styles on the listing page.
     */
    public function setMedia()
    {
        parent::setMedia();
        $this->addCSS($this->module->getPathUri().'views/css/fhregions.css');
    }
}