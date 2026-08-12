<?php
/**
 * Informational UP regions discovery module.
 *
 * @license OSL-3.0
 */
if (!defined('_PS_VERSION_')) {
    exit;
}

require_once dirname(__FILE__).'/classes/FhRegionsDb.php';
require_once dirname(__FILE__).'/classes/FhRegion.php';

/**
 * Manages curated UP regions used to discover farmstays and local activities.
 *
 * Regions are informational discovery content. They never add inventory,
 * availability, cart lines, checkout steps or payment requirements.
 */
class Fhregions extends Module
{
    /**
     * Initialise module metadata.
     */
    public function __construct()
    {
        $this->name = 'fhregions';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'QloApps Marketplace';
        $this->need_instance = 0;
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('UP regions');
        $this->description = $this->l('Curated Uttar Pradesh regions for discovering farmstays and rural activities.');
    }

    /**
     * Create content storage, seed demo regions and register presentation hooks.
     *
     * @return bool
     */
    public function install()
    {
        $database = new FhRegionsDb();
        $dir = _PS_IMG_.'fhregions';
        if (!is_dir($dir) && !@mkdir($dir, 0777, true) && !is_dir($dir)) {
            return false;
        }

        return parent::install()
            && $database->createTables()
            && $this->seedDemoRegions()
            && $this->registerHook(array(
                'displayHome',
                'displayDefaultNavigationHook',
                'displayFooterExploreSectionHook',
                'actionObjectLanguageAddAfter',
            ))
            && $this->installTab('AdminFhRegion', $this->l('UP regions'));
    }

    /**
     * Remove module registrations without deleting editorial data.
     *
     * Regions and links are retained so an accidental uninstall cannot remove content.
     *
     * @return bool
     */
    public function uninstall()
    {
        return parent::uninstall() && $this->uninstallTabs();
    }

    /**
     * Open the region manager from the Modules page.
     *
     * @return void
     */
    public function getContent()
    {
        Tools::redirectAdmin($this->context->link->getAdminLink('AdminFhRegion'));
    }

    /**
     * Add an administration entry for region content.
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
     * Populate region translations when an administrator adds a language.
     *
     * @param array $params Hook parameters.
     */
    public function hookActionObjectLanguageAddAfter($params)
    {
        if (isset($params['object']->id) && (int) $params['object']->id) {
            HotelHelper::updateLangTables((int) $params['object']->id, array('fhdiscover_region'));
        }
    }

    /**
     * Insert demo regions on first install so the discovery surfaces render.
     *
     * Demo content only — administrators can edit or extend via the admin UI.
     *
     * @return bool
     */
    private function seedDemoRegions()
    {
        if ((int) Db::getInstance()->getValue(
            'SELECT COUNT(*) FROM `'._DB_PREFIX_.'fhdiscover_region`'
        ) > 0) {
            return true;
        }

        $languages = Language::getLanguages(false);
        $idLang = (int) Context::getContext()->language->id;
        if (!$languages) {
            return true;
        }

        $regions = array(
            array(
                'name' => 'Bundelkhand',
                'position' => 1,
                'active' => 1,
                'blurb' => 'Bundelkhand\'s rock-cut landscapes, forest fringes and fort towns - quiet farmstays between orchards and ravines.',
                'description' => '<p>Bundelkhand is the heartland of central Uttar Pradesh - undulating granite country, dense golden-hair forests and the storied forts of Jhansi, Kalinjar and Mahoba. Farmstays here sit between citrus orchards, millet fields and village ponds, with easy day trips to Panna\'s wildlife corridor and the Ken-Betwa river country.</p>',
            ),
            array(
                'name' => 'Awadh',
                'position' => 2,
                'active' => 1,
                'blurb' => 'The nawabi heartland around Lucknow - mango orchards, riverine villages and the fine arts of chikan and cuisine.',
                'description' => '<p>Awadh, the country around Lucknow and the Gomti river, pairs refined nawabi culture with a slow rural rhythm. Stay in orchard farmhouses, learn chikan embroidery in village workshops and eat from the region\'s famous dum-style kitchens.</p>',
            ),
            array(
                'name' => 'Braj',
                'position' => 3,
                'active' => 1,
                'blurb' => 'Krishna\'s country - Mathura, Vrindavan and the ghat towns of the Yamuna, ringed by pastoral villages.',
                'description' => '<p>Braj is the sacred pastoral landscape of Krishna\'s childhood - the ghats of Mathura and Vrindavan, the Govardhan hill and hundreds of hamlets tied to a living tradition of devotion and craft. Farmstays offer temple walks, village art and the sweets of the region.</p>',
            ),
            array(
                'name' => 'Purvanchal',
                'position' => 4,
                'active' => 1,
                'blurb' => 'Eastern UP\'s river plains - the Ghaghra and the Ganga, mango groves, weavers and the holy cities of the Sarayu.',
                'description' => '<p>Purvanchal stretches from Ayodhya on the Sarayu eastwards across the Ghaghra plain. It is a country of mango orchards, handloom weavers and river ghats - slower, older and deeply connected to the holy rivers that shape it.</p>',
            ),
            array(
                'name' => 'Rohilkhand',
                'position' => 5,
                'active' => 1,
                'blurb' => 'The green belt of Bareilly and Pilibhit - sugar-cane country, tiger forests and the terai wetlands.',
                'description' => '<p>Rohilkhand is the fertile northern plain where sugarcane, mangoes and the terai forests meet. Pilibhit\'s tiger reserve and the wetlands of the Surai river make it one of Uttar Pradesh\'s best birdwatching territories, with farmstays on working cane farms.</p>',
            ),
            array(
                'name' => 'Kashi',
                'position' => 6,
                'active' => 1,
                'blurb' => 'The Varanasi country - ghats of the Ganga, Banarasi silk and sarnath\'s calm, ringed by weaving villages.',
                'description' => '<p>The Varanasi region is Uttar Pradesh\'s most visited landscape - the ghats of Kashi, the deer park of Sarnath and the silk-weaving villages of the Gangetic plain. Stay outside the city in farmhouses and walk into the weaving looms that make Banarasi silk.</p>',
            ),
        );

        $db = Db::getInstance();
        $now = date('Y-m-d H:i:s');

        foreach ($regions as $index => $region) {
            if (!$db->insert(
                'fhdiscover_region',
                array(
                    'active' => $region['active'],
                    'position' => $region['position'],
                    'date_add' => $now,
                    'date_upd' => $now,
                ),
                false, // nullValues
                true, // useCache
                Db::ON_DUPLICATE_KEY
            )) {
                return false;
            }

            $idRegion = (int) $db->Insert_ID();
            foreach ($languages as $language) {
                if (!$db->insert(
                    'fhdiscover_region_lang',
                    array(
                        'id_region' => $idRegion,
                        'id_lang' => (int) $language['id_lang'],
                        'name' => pSQL($region['name']),
                        'blurb' => pSQL($region['blurb']),
                        'description' => pSQL($region['description']),
                    )
                )) {
                    return false;
                }
            }
        }

        // Demo linkage: attach the first active property to the first region so
        // the detail page has real content to show. Reassign via the admin UI.
        $idHotel = (int) Db::getInstance()->getValue(
            'SELECT `id` FROM `'._DB_PREFIX_.'htl_branch_info` WHERE `active` = 1 ORDER BY `id` ASC'
        );
        if (Validate::isUnsignedId($idHotel)) {
            $db->insert('fhdiscover_region_hotel', array('id_region' => 1, 'id_hotel' => $idHotel));
        }

        return true;
    }

    /**
     * Render the region preview strip on the home page.
     *
     * @param array $params Hook parameters.
     *
     * @return string
     */
    public function hookDisplayHome($params)
    {
        if (!isset($this->context->controller->php_self) || $this->context->controller->php_self !== 'index') {
            return '';
        }

        $idLang = (int) $this->context->language->id;
        $regions = FhRegion::getForHome($idLang, 6);
        if (!$regions) {
            return '';
        }

        $activities = array();
        $activitiesUrl = '';
        if (Module::isEnabled('ruralactivities')) {
            $activities = RuralActivity::getPage($idLang, 0, 1, 8);
            $activitiesUrl = $this->context->link->getModuleLink('ruralactivities', 'activities');
        }

        $this->context->smarty->assign(array(
            'fh_regions_home' => $regions,
            'fh_regions_home_url' => $this->context->link->getModuleLink($this->name, 'region'),
            'fh_region_detail_url' => $this->context->link->getModuleLink($this->name, 'regiondetail'),
            'fh_activities_home' => $activities,
            'fh_activities_home_url' => $activitiesUrl,
        ));

        return $this->display(__FILE__, 'home-preview.tpl');
    }

    /**
     * Render the discovery navigation links inside the mobile nav drawer.
     *
     * Acts as the discovery hub: shows Regions plus the Activities and Stories
     * links when their modules are installed and enabled.
     *
     * @param array $params Hook parameters.
     *
     * @return string
     */
    public function hookDisplayDefaultNavigationHook($params)
    {
        $links = array();
        $links[] = array(
            'name' => $this->l('Regions'),
            'link' => $this->context->link->getModuleLink($this->name, 'region'),
        );

        if (Module::isEnabled('ruralactivities')) {
            $links[] = array(
                'name' => $this->l('Activities'),
                'link' => $this->context->link->getModuleLink('ruralactivities', 'activities'),
            );
        }

        if (Module::isEnabled('fhblog')) {
            $links[] = array(
                'name' => $this->l('Stories'),
                'link' => $this->context->link->getModuleLink('fhblog', 'blog'),
            );
        }

        $this->context->smarty->assign('fh_discovery_links', $links);

        return $this->display(__FILE__, 'nav-links.tpl');
    }

    /**
     * Render the discovery links in the footer explore section.
     *
     * @param array $params Hook parameters.
     *
     * @return string
     */
    public function hookDisplayFooterExploreSectionHook($params)
    {
        $links = array();
        $links[] = array(
            'name' => $this->l('Regions'),
            'link' => $this->context->link->getModuleLink($this->name, 'region'),
        );

        if (Module::isEnabled('ruralactivities')) {
            $links[] = array(
                'name' => $this->l('Activities'),
                'link' => $this->context->link->getModuleLink('ruralactivities', 'activities'),
            );
        }

        if (Module::isEnabled('fhblog')) {
            $links[] = array(
                'name' => $this->l('Stories'),
                'link' => $this->context->link->getModuleLink('fhblog', 'blog'),
            );
        }

        $this->context->smarty->assign('fh_discovery_links', $links);

        return $this->display(__FILE__, 'footer-explore.tpl');
    }
}