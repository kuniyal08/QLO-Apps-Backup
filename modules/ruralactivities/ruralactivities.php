<?php
/**
 * Informational rural activities module.
 *
 * @license AFL-3.0
 */
if (!defined('_PS_VERSION_')) {
    exit;
}

require_once dirname(__FILE__).'/classes/RuralActivitiesDb.php';
require_once dirname(__FILE__).'/classes/RuralActivity.php';

/**
 * Manages property-linked activities that are not bookable products.
 */
class Ruralactivities extends Module
{
    /**
     * Initialise module metadata.
     */
    public function __construct()
    {
        $this->name = 'ruralactivities';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'QloApps Marketplace';
        $this->need_instance = 0;
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('Rural activities');
        $this->description = $this->l('Shows informational local activities for each property.');
    }

    /**
     * Create content storage and register presentation hooks.
     *
     * @return bool
     */
    public function install()
    {
        $database = new RuralActivitiesDb();

        return parent::install()
            && $database->createTables()
            && $this->registerHook(array(
                'displayProductTab',
                'displayProductTabContent',
                'displayHeader',
                'actionObjectLanguageAddAfter',
            ))
            && $this->installTab('AdminRuralActivities', $this->l('Rural activities'));
    }

    /**
     * Remove module registrations without deleting editorial data.
     *
     * Activities are retained so an accidental uninstall cannot remove content.
     *
     * @return bool
     */
    public function uninstall()
    {
        return parent::uninstall() && $this->uninstallTabs();
    }

    /**
     * Open the activity manager from the Modules page.
     *
     * @return void
     */
    public function getContent()
    {
        Tools::redirectAdmin($this->context->link->getAdminLink('AdminRuralActivities'));
    }

    /**
     * Add an administration entry for activity content.
     *
     * @param string $className Admin controller class.
     * @param string $tabName Localised tab label.
     *
     * @return bool
     */
    private function installTab($className, $tabName)
    {
        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = $className;
        $tab->id_parent = -1;
        $tab->module = $this->name;

        foreach (Language::getLanguages(false) as $language) {
            $tab->name[(int) $language['id_lang']] = $tabName;
        }

        return (bool) $tab->add();
    }

    /**
     * Remove administration entries owned by this module.
     *
     * @return bool
     */
    private function uninstallTabs()
    {
        foreach (Tab::getCollectionFromModule($this->name) as $tab) {
            if (!$tab->delete()) {
                return false;
            }
        }

        return true;
    }

    /**
     * Populate activity translations when an administrator adds a language.
     *
     * @param array $params Hook parameters.
     */
    public function hookActionObjectLanguageAddAfter($params)
    {
        if (isset($params['object']->id) && (int) $params['object']->id) {
            HotelHelper::updateLangTables((int) $params['object']->id, array('rural_activity'));
        }
    }

    /**
     * Render the activity tab only for bookable room products.
     *
     * @param array $params Hook parameters.
     *
     * @return string
     */
    public function hookDisplayProductTab($params)
    {
        if (isset($params['product']->booking_product) && $params['product']->booking_product) {
            return $this->display(__FILE__, 'product-tab.tpl');
        }

        return '';
    }

    /**
     * Load activity styling only on room detail pages.
     *
     * @return void
     */
    public function hookDisplayHeader()
    {
        if (isset($this->context->controller->php_self) && $this->context->controller->php_self === 'product') {
            $this->context->controller->addCSS($this->_path.'views/css/ruralactivities.css');
        }
    }

    /**
     * Render property activities as read-only editorial content.
     *
     * @param array $params Hook parameters.
     *
     * @return string
     */
    public function hookDisplayProductTabContent($params)
    {
        if (empty($params['product']->booking_product) || empty($params['product']->id)) {
            return '';
        }

        $roomType = (new HotelRoomType())->getRoomTypeInfoByIdProduct((int) $params['product']->id);
        if (!$roomType || empty($roomType['id_hotel'])) {
            return '';
        }

        $activities = RuralActivity::getByHotel(
            (int) $roomType['id_hotel'],
            (int) $this->context->language->id,
            1,
            6
        );
        if (!$activities) {
            return '';
        }

        $this->context->smarty->assign(array('rural_activities' => $activities));

        return $this->display(__FILE__, 'product-tab-content.tpl');
    }
}
