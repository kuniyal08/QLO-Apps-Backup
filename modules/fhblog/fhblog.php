<?php
/**
 * Informational farmstay stories blog module.
 *
 * @license OSL-3.0
 */
if (!defined('_PS_VERSION_')) {
    exit;
}

require_once dirname(__FILE__).'/classes/FhBlogDb.php';
require_once dirname(__FILE__).'/classes/FhBlogCategory.php';
require_once dirname(__FILE__).'/classes/FhBlogPost.php';

/**
 * Manages editorial farmstay stories, village guides and activity features.
 *
 * Posts are informational discovery content. They never add inventory,
 * availability, cart lines, checkout steps or payment requirements.
 */
class Fhblog extends Module
{
    /**
     * Initialise module metadata.
     */
    public function __construct()
    {
        $this->name = 'fhblog';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'QloApps Marketplace';
        $this->need_instance = 0;
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('Farmstay stories');
        $this->description = $this->l('Editorial farmstay stories, village guides and activity features.');
    }

    /**
     * Create content storage, seed demo posts and register presentation hooks.
     *
     * @return bool
     */
    public function install()
    {
        $database = new FhBlogDb();
        $dir = _PS_IMG_.'fhblog';
        if (!is_dir($dir) && !@mkdir($dir, 0777, true) && !is_dir($dir)) {
            return false;
        }

        return parent::install()
            && $database->createTables()
            && $this->seedDemoContent()
            && $this->registerHook(array(
                'displayHome',
                'actionObjectLanguageAddAfter',
            ))
            && $this->installTab('AdminFhBlogPost', $this->l('Farmstay stories'))
            && $this->installTab('AdminFhBlogCategory', $this->l('Story categories'));
    }

    /**
     * Remove module registrations without deleting editorial data.
     *
     * @return bool
     */
    public function uninstall()
    {
        return parent::uninstall() && $this->uninstallTabs();
    }

    /**
     * Open the post manager from the Modules page.
     *
     * @return void
     */
    public function getContent()
    {
        Tools::redirectAdmin($this->context->link->getAdminLink('AdminFhBlogPost'));
    }

    /**
     * Add an administration entry for blog content.
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
     * Populate post and category translations when a language is added.
     *
     * @param array $params Hook parameters.
     */
    public function hookActionObjectLanguageAddAfter($params)
    {
        if (isset($params['object']->id) && (int) $params['object']->id) {
            HotelHelper::updateLangTables((int) $params['object']->id, array('fhdiscover_blog_post', 'fhdiscover_blog_category'));
        }
    }

    /**
     * Render the latest posts teaser on the home page.
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
        $posts = FhBlogPost::getLatest($idLang, 3);
        if (!$posts) {
            return '';
        }

        $this->context->smarty->assign(array(
            'fh_blog_home' => $posts,
            'fh_blog_home_url' => $this->context->link->getModuleLink($this->name, 'blog'),
        ));

        return $this->display(__FILE__, 'home-teaser.tpl');
    }

    /**
     * Insert demo categories and posts on first install.
     *
     * Demo content only — administrators can edit or extend via the admin UI.
     *
     * @return bool
     */
    private function seedDemoContent()
    {
        if ((int) Db::getInstance()->getValue(
            'SELECT COUNT(*) FROM `'._DB_PREFIX_.'fhdiscover_blog_post`'
        ) > 0) {
            return true;
        }

        $languages = Language::getLanguages(false);
        if (!$languages) {
            return true;
        }

        $categories = array(
            1 => 'Farmstay Stories',
            2 => 'Village Guides',
            3 => 'Activities',
            4 => 'Government & Policy',
        );

        $db = Db::getInstance();
        $now = date('Y-m-d H:i:s');

        foreach ($categories as $position => $categoryName) {
            if (!$db->insert('fhdiscover_blog_category', array('position' => $position, 'active' => 1))) {
                return false;
            }
            $idCategory = (int) $db->Insert_ID();
            foreach ($languages as $language) {
                if (!$db->insert('fhdiscover_blog_category_lang', array(
                    'id_blog_category' => $idCategory,
                    'id_lang' => (int) $language['id_lang'],
                    'name' => pSQL($categoryName),
                ))) {
                    return false;
                }
            }
        }

        $posts = array(
            array(
                'category' => 1,
                'title' => 'A night on a Bundelkhand farm',
                'slug' => 'a-night-on-a-bundelkhand-farm',
                'excerpt' => 'Fireflies over the pond, millet rotis on a clay stove and the quiet of a working farm - one traveller\'s first farmstay.',
                'content' => '<p>The lane to the farmhouse ends at a kothi painted pale blue, facing a pond that glows green with lotus in the evenings. Our host, a retired teacher, walks us through the mustard crop before dark and hands us the churn for the evening\'s buttermilk.</p><p>Supper is millet rotis cooked on a clay stove, dal from the family plot and a mango pickle older than our host\'s grandchildren. There is no television. There is no hurry.</p><p>At dawn the farm wakes with the birds - parakeets stripping the guava trees, a pair of sarus cranes in the far field. This is the whole point of a farmstay: to live, for a night, inside the rhythm you normally only read about.</p>',
                'author' => 'The QloApps Editorial Desk',
                'days_ago' => 6,
            ),
            array(
                'category' => 2,
                'title' => 'Village guide: Chanderi\'s weaving country',
                'slug' => 'village-guide-chanderi-weaving-country',
                'excerpt' => 'The handloom belt of Bundelkhand, where muslin is woven to the rhythm of the village loom - and where to stay while you watch.',
                'content' => '<p>Chanderi\'s muslin has been woven for centuries, but the living part of it happens in the lanes around the town, where every third house has a loom in the courtyard.</p><p>Visitors can sit with weavers for an afternoon, trace the pattern book of a nine-yard sari, and buy directly from the family that made it. The nearest farmstays are a short drive into the countryside - book two nights and pace the silk district and the fort on separate days.</p>',
                'author' => 'The QloApps Editorial Desk',
                'days_ago' => 13,
            ),
            array(
                'category' => 3,
                'title' => 'Five farm activities you can actually join',
                'slug' => 'five-farm-activities-you-can-actually-join',
                'excerpt' => 'From churning butter to night birdwatching - the experiences UP farmstays now offer, and what each involves.',
                'content' => '<p>Farm stays in Uttar Pradesh now bundle stays with real farm life. The five activities guests join most:</p><p><strong>1. Morning milking and churning.</strong> Dairy is the heart of most farmstays - guests milk the cows at dawn and churn butter for breakfast.</p><p><strong>2. Field-to-plate cooking.</strong> Harvest what is in season, then cook it on a clay stove with the family.</p><p><strong>3. Fishpond afternoons.</strong> Many farms have rearing ponds; the catch becomes dinner.</p><p><strong>4. Farm walks with a guide.</strong> Crop cycles, soil and the economics of a working farm, explained by the people who run it.</p><p><strong>5. Night birdwatching.</strong> The terai wetlands and village ponds are among northern India\'s best - carry binoculars.</p>',
                'author' => 'The QloApps Editorial Desk',
                'days_ago' => 20,
            ),
            array(
                'category' => 4,
                'title' => 'Understanding UP\'s farm stay policy',
                'slug' => 'understanding-ups-farm-stay-policy',
                'excerpt' => 'The 2025 farm stay investment drive and B&B/homestay policy explained - and what it means for the properties you stay in.',
                'content' => '<p>In late 2025, the Government of Uttar Pradesh launched an investment drive for farm stays: rural properties with at least two lettable rooms, a reception area and a menu of farm activities - agri-farming, horticulture, fishponds, dairy and farm tours - eligible for capital-subsidy support.</p><p>The parallel B&B/Homestay Policy 2025 streamlines registration under the state tourism portal, making small rural operators eligible to host guests formally, with single-window approvals.</p><p>For travellers this means the supply of genuine, registered farm stays is growing fast across the state - and for operators it means a clear legal route to hosting. Every property on this platform follows these frameworks, and stays are booked directly with the property, with no third-party commission mark-ups.</p>',
                'author' => 'The QloApps Editorial Desk',
                'days_ago' => 27,
            ),
        );

        foreach ($posts as $post) {
            $dateAdd = date('Y-m-d H:i:s', strtotime('-'.$post['days_ago'].' days'));
            if (!$db->insert('fhdiscover_blog_post', array(
                'id_blog_category' => $post['category'],
                'active' => 1,
                'date_add' => $dateAdd,
                'date_upd' => $dateAdd,
            ))) {
                return false;
            }
            $idPost = (int) $db->Insert_ID();
            foreach ($languages as $language) {
                if (!$db->insert('fhdiscover_blog_post_lang', array(
                    'id_blog_post' => $idPost,
                    'id_lang' => (int) $language['id_lang'],
                    'title' => pSQL($post['title']),
                    'slug' => pSQL($post['slug']),
                    'excerpt' => pSQL($post['excerpt']),
                    'content' => pSQL($post['content']),
                    'author' => pSQL($post['author']),
                    'meta_title' => pSQL($post['title']),
                    'meta_description' => pSQL($post['excerpt']),
                ))) {
                    return false;
                }
            }
        }

        return true;
    }
}