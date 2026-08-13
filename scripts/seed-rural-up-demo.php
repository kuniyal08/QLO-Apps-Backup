<?php
/**
 * Creates the client-demo Rural UP farmstays through QloApps models.
 *
 * This command never changes reservation, availability, cart, checkout or
 * payment logic. It is idempotent and is intentionally limited to demo names.
 */

require '/var/www/html/config/config.inc.php';
require_once _PS_MODULE_DIR_.'fhregions/classes/FhRegion.php';
require_once _PS_MODULE_DIR_.'wkhotelroom/classes/WkHotelRoomDisplay.php';
require_once _PS_MODULE_DIR_.'wkhotelfeaturesblock/classes/WkHotelFeaturesData.php';

$context = Context::getContext();
$idLang = (int) Configuration::get('PS_LANG_DEFAULT');
$idCountry = (int) Db::getInstance()->getValue(
    'SELECT `id_country` FROM `'._DB_PREFIX_.'country_lang` WHERE `id_lang` = '.$idLang.' AND `name` = "India"'
);
$idState = (int) Db::getInstance()->getValue(
    'SELECT `id_state` FROM `'._DB_PREFIX_.'state` WHERE `name` = "Uttar Pradesh"'
);

if (!$idCountry) {
    throw new RuntimeException('India must be configured before demo properties can be seeded.');
}

$properties = array(
    array('region' => 'Awadh', 'name' => 'Gomti Mango House', 'city' => 'Malihabad', 'postcode' => '226102', 'address' => 'Mango Orchard Road, Malihabad', 'price' => 7200, 'image' => 'demo-gomti-mango-house.jpg', 'room' => 'Orchard Verandah Suite', 'copy' => 'A demonstration farmhouse outside Lucknow, imagined for long mango-season lunches and quiet Gomti evenings.'),
    array('region' => 'Bundelkhand', 'name' => 'Orchard Ridge Farmstay', 'city' => 'Jhansi', 'postcode' => '284001', 'address' => 'Granite Ridge Road, Jhansi', 'price' => 6100, 'image' => 'demo-orchard-ridge.jpg', 'room' => 'Granite Ridge Cottage', 'copy' => 'A demonstration countryside stay framed by orchards, open rock country and slow sunsets in Bundelkhand.'),
    array('region' => 'Braj', 'name' => 'Yamuna Courtyard Farmstay', 'city' => 'Mathura', 'postcode' => '281001', 'address' => 'Riverside Village Road, Mathura', 'price' => 6800, 'image' => 'demo-yamuna-courtyard.jpg', 'room' => 'Courtyard Garden Room', 'copy' => 'A demonstration farmstay near the Yamuna, imagined around shaded courtyards, village walks and Braj mornings.'),
    array('region' => 'Purvanchal', 'name' => 'Sarayu Fields Retreat', 'city' => 'Ayodhya', 'postcode' => '224001', 'address' => 'Sarayu Fields Road, Ayodhya', 'price' => 5900, 'image' => 'demo-sarayu-fields.jpg', 'room' => 'Sarayu Field Cabin', 'copy' => 'A demonstration retreat for river plains, rice fields and unhurried days close to the Sarayu.'),
    array('region' => 'Rohilkhand', 'name' => 'Terai Wetlands Farmstay', 'city' => 'Pilibhit', 'postcode' => '262001', 'address' => 'Wetlands Track, Pilibhit', 'price' => 7600, 'image' => 'demo-terai-wetlands.jpg', 'room' => 'Wetland Watch Suite', 'copy' => 'A demonstration farmstay for bird-rich wetlands, cane fields and the softer edge of the Terai.'),
    array('region' => 'Kashi', 'name' => 'Ganga Looms Country House', 'city' => 'Varanasi', 'postcode' => '221001', 'address' => 'Loom Village Lane, Varanasi', 'price' => 7400, 'image' => 'demo-ganga-looms.jpg', 'room' => 'Weaver\'s Courtyard Room', 'copy' => 'A demonstration country house beyond Varanasi, imagined around handlooms, fields and the Ganga plain.'),
);

$refreshImages = in_array('--refresh-images', $argv, true);

$regionCovers = array(
    'Awadh' => 'region-awadh.jpg',
    'Bundelkhand' => 'region-bundelkhand.jpg',
    'Braj' => 'region-braj.jpg',
    'Purvanchal' => 'region-purvanchal.jpg',
    'Rohilkhand' => 'region-rohilkhand.jpg',
    'Kashi' => 'region-kashi.jpg',
);
$demoProductIds = array();
$demoRegionHotels = array();

foreach ($regionCovers as $regionName => $filename) {
    addRegionCover($regionName, $filename, $idLang, $refreshImages);
}

foreach ($properties as $position => $data) {
    $hotel = getDemoHotel($data['name'], $idLang);
    if (!$hotel) {
        $hotel = createHotel($data, $idLang, $idCountry, $idState);
    }

    addHotelImage($hotel, $data['image'], $refreshImages);
    $product = getDemoRoom($hotel->id, $data['room'], $idLang);
    if (!$product) {
        $product = createRoom($hotel, $data, $idLang);
    }
    $demoProductIds[] = (int) $product->id;
    addProductImage($product, $data['image'], $refreshImages);
    addPhysicalRooms($hotel->id, $product->id, $data['region']);
    $demoRegionHotels[$data['region']][] = (int) $hotel->id;
    addHomepageSelection($product->id, $position);
    echo 'Ready: '.$data['name'].PHP_EOL;
}

limitHomepageToDemoProperties($demoProductIds);
syncRegionLinks($demoRegionHotels, $idLang);
syncFeatureBlocks($idLang);
syncStoryCovers($idLang, $refreshImages);
ensurePropertiesPage($idLang);

function getDemoHotel($name, $idLang)
{
    $idHotel = (int) Db::getInstance()->getValue(
        'SELECT `id` FROM `'._DB_PREFIX_.'htl_branch_info_lang` WHERE `id_lang` = '.(int) $idLang.' AND `hotel_name` = "'.pSQL($name).'"'
    );
    return $idHotel ? new HotelBranchInformation($idHotel, $idLang) : false;
}

function createHotel($data, $idLang, $idCountry, $idState)
{
    $hotel = new HotelBranchInformation();
    $hotel->active = 1;
    $hotel->active_refund = 0;
    $hotel->email = Tools::link_rewrite($data['name']).'@demo.ruralup.local';
    $hotel->rating = 4;
    $hotel->check_in = '14:00';
    $hotel->check_out = '11:00';
    $hotel->latitude = 0;
    $hotel->longitude = 0;
    $hotel->hotel_name = array($idLang => $data['name']);
    $hotel->short_description = array($idLang => $data['copy'].' Demo stay with representative imagery.');
    $hotel->description = array($idLang => '<p>'.$data['copy'].' This client-demo listing uses representative imagery and is ready for real content replacement.</p>');
    $hotel->policies = array($idLang => '<p>Demo property. Booking controls use the standard QloApps flow.</p>');
    if (!$hotel->add()) {
        throw new RuntimeException('Could not create '.$data['name']);
    }

    $address = new Address();
    $address->id_hotel = (int) $hotel->id;
    $address->id_country = (int) $idCountry;
    $address->id_state = (int) $idState;
    $address->firstname = $data['name'];
    $address->lastname = 'Demo';
    $address->alias = substr($data['name'], 0, 32);
    $address->address1 = $data['address'];
    $address->city = $data['city'];
    $address->postcode = $data['postcode'];
    $address->phone = '9000000000';
    if (!$address->add()) {
        throw new RuntimeException('Could not create address for '.$data['name']);
    }

    $groups = array_column(Group::getGroups($idLang), 'id_group');
    $country = new Country($idCountry, $idLang);
    $countryCategory = $hotel->addCategory(array('name' => $country->name, 'group_ids' => $groups));
    $stateCategory = $hotel->addCategory(array('name' => 'Uttar Pradesh', 'group_ids' => $groups, 'parent_category' => $countryCategory));
    $cityCategory = $hotel->addCategory(array('name' => $data['city'], 'group_ids' => $groups, 'parent_category' => $stateCategory));
    $hotelCategory = $hotel->addCategory(array(
        'name' => $hotel->hotel_name,
        'group_ids' => $groups,
        'parent_category' => $cityCategory,
        'is_hotel' => 1,
        'id_hotel' => (int) $hotel->id,
        'link_rewrite' => array($idLang => Tools::link_rewrite($data['name'])),
        'meta_title' => array($idLang => $data['name'].' | Rural UP'),
        'meta_description' => array($idLang => 'Demo stay with representative imagery.'),
    ));
    $hotel->id_category = (int) $hotelCategory;
    $hotel->update();
    Category::regenerateEntireNtree();
    return $hotel;
}

function addHotelImage($hotel, $filename, $refreshImages = false)
{
    $source = _PS_THEME_DIR_.'img/editorial/'.$filename;
    if ($refreshImages) {
        $objImage = new HotelImage();
        foreach ((array) $objImage->getImagesByHotelId((int) $hotel->id) as $row) {
            $image = new HotelImage((int) $row['id']);
            $image->delete();
        }
    }
    if ($cover = HotelImage::getCover((int) $hotel->id)) {
        $image = new HotelImage((int) $cover['id']);
        $path = $image->getPathForCreation();
        if (!file_exists($path.$image->id.'.'.$image->image_format)) {
            ImageManager::resize($source, $path.$image->id.'.'.$image->image_format);
            foreach (ImageType::getImagesTypes('hotels') as $type) {
                ImageManager::resize($source, $path.$image->id.'-'.$type['name'].'.'.$image->image_format, (int) $type['width'], (int) $type['height']);
            }
        }
        return;
    }
    $upload = array('tmp_name' => $source);
    if (!(new HotelImage())->uploadHotelImages($upload, (int) $hotel->id)) {
        throw new RuntimeException('Could not attach hotel image for '.$hotel->id);
    }
}

function getDemoRoom($idHotel, $name, $idLang)
{
    $idProduct = (int) Db::getInstance()->getValue(
        'SELECT hrt.`id_product` FROM `'._DB_PREFIX_.'htl_room_type` hrt INNER JOIN `'._DB_PREFIX_.'product_lang` pl ON pl.`id_product` = hrt.`id_product` AND pl.`id_lang` = '.(int) $idLang.' WHERE hrt.`id_hotel` = '.(int) $idHotel.' AND pl.`name` = "'.pSQL($name).'"'
    );
    return $idProduct ? new Product($idProduct, false, $idLang) : false;
}

function createRoom($hotel, $data, $idLang)
{
    $product = new Product();
    $product->active = 1;
    $product->booking_product = 1;
    $product->is_virtual = 1;
    $product->show_at_front = 1;
    $product->visibility = 'both';
    $product->available_for_order = 1;
    $product->id_tax_rules_group = 1;
    $product->id_category_default = (int) $hotel->id_category;
    $product->price = (float) $data['price'];
    $product->name = array($idLang => $data['room']);
    $product->description_short = array($idLang => $data['copy'].' Demo room type for booking-flow validation.');
    $product->description = array($idLang => '<p>'.$data['copy'].' Demo room type for booking-flow validation.</p>');
    $product->link_rewrite = array($idLang => Tools::link_rewrite($data['room']));
    $product->meta_title = array($idLang => $data['room'].' | Rural UP');
    $product->meta_description = array($idLang => 'Demo room with representative imagery.');
    if (!$product->add()) {
        throw new RuntimeException('Could not create room type for '.$hotel->id);
    }
    $product->updateCategories($hotel->getAllHotelCategories(array(), (int) $hotel->id));

    $roomType = new HotelRoomType();
    $roomType->id_product = (int) $product->id;
    $roomType->id_hotel = (int) $hotel->id;
    $roomType->adults = 2;
    $roomType->children = 0;
    $roomType->max_adults = 2;
    $roomType->max_children = 1;
    $roomType->max_guests = 3;
    $roomType->min_los = 1;
    $roomType->max_los = 0;
    if (!$roomType->add()) {
        throw new RuntimeException('Could not link room type for '.$hotel->id);
    }
    return $product;
}

function addProductImage($product, $filename, $refreshImages = false)
{
    if ($refreshImages) {
        $objProduct = new Product((int) $product->id, false, (int) Configuration::get('PS_LANG_DEFAULT'));
        foreach ((array) $objProduct->getImages((int) $product->id) as $row) {
            $image = new Image((int) $row['id_image']);
            $image->delete();
        }
    }
    if (Product::getCover((int) $product->id)) {
        return;
    }
    $source = _PS_THEME_DIR_.'img/editorial/'.$filename;
    $image = new Image();
    $image->id_product = (int) $product->id;
    $image->position = 1;
    $image->cover = 1;
    if (!$image->add()) {
        throw new RuntimeException('Could not create product image record for '.$product->id);
    }
    $path = $image->getPathForCreation();
    if (!ImageManager::resize($source, $path.'.jpg')) {
        throw new RuntimeException('Could not save product image for '.$product->id);
    }
    foreach (ImageType::getImagesTypes('products') as $type) {
        ImageManager::resize($source, $path.'-'.$type['name'].'.jpg', (int) $type['width'], (int) $type['height']);
    }
}

function addPhysicalRooms($idHotel, $idProduct, $prefix)
{
    if ((int) Db::getInstance()->getValue('SELECT COUNT(*) FROM `'._DB_PREFIX_.'htl_room_information` WHERE `id_product` = '.(int) $idProduct) >= 2) {
        return;
    }
    for ($room = 1; $room <= 2; $room++) {
        $physicalRoom = new HotelRoomInformation();
        $physicalRoom->id_hotel = (int) $idHotel;
        $physicalRoom->id_product = (int) $idProduct;
        $physicalRoom->room_num = strtoupper(substr(Tools::link_rewrite($prefix), 0, 3)).'-D'.$room;
        $physicalRoom->floor = 'Ground';
        $physicalRoom->comment = 'Demo inventory';
        $physicalRoom->id_status = HotelRoomInformation::STATUS_ACTIVE;
        if (!$physicalRoom->add()) {
            throw new RuntimeException('Could not create physical room for '.$idProduct);
        }
    }
}

/**
 * Replace each region's hotel set with the demo farmstays, removing stale
 * links (for example hotels linked by earlier seeder versions).
 *
 * @param array $demoRegionHotels Region name => hotel IDs.
 * @param int $idLang Language ID.
 */
function syncRegionLinks($demoRegionHotels, $idLang)
{
    foreach ($demoRegionHotels as $regionName => $ids) {
        $idRegion = (int) Db::getInstance()->getValue(
            'SELECT `id_region` FROM `'._DB_PREFIX_.'fhdiscover_region_lang` WHERE `id_lang` = '.(int) $idLang.' AND `name` = "'.pSQL($regionName).'"'
        );
        if (!$idRegion) {
            throw new RuntimeException('Could not locate region '.$regionName);
        }
        FhRegion::setHotelIds($idRegion, $ids);
    }
}

function addRegionCover($regionName, $filename, $idLang, $refreshImages = false)
{
    $idRegion = (int) Db::getInstance()->getValue(
        'SELECT `id_region` FROM `'._DB_PREFIX_.'fhdiscover_region_lang` WHERE `id_lang` = '.(int) $idLang.' AND `name` = "'.pSQL($regionName).'"'
    );
    if (!$idRegion) {
        throw new RuntimeException('Could not locate region '.$regionName);
    }
    $region = new FhRegion($idRegion, $idLang);
    if ($region->cover && !$refreshImages) {
        return;
    }
    $source = _PS_THEME_DIR_.'img/editorial/'.$filename;
    $targetName = 'demo-region-'.Tools::link_rewrite($regionName).'.jpg';
    $target = _PS_IMG_DIR_.'fhregions/'.$targetName;
    if (!is_dir(dirname($target)) && !mkdir(dirname($target), 0775, true)) {
        throw new RuntimeException('Could not create region media directory.');
    }
    if (!ImageManager::resize($source, $target, 1600, 900)) {
        throw new RuntimeException('Could not save region cover for '.$regionName);
    }
    $region->cover = $targetName;
    if (!$region->update()) {
        throw new RuntimeException('Could not update region cover for '.$regionName);
    }
}

function addHomepageSelection($idProduct, $position)
{
    $display = new WkHotelRoomDisplay();
    if ($existing = $display->gerRoomByIdProduct((int) $idProduct)) {
        $display = new WkHotelRoomDisplay((int) $existing['id_room_block']);
    }
    $display->id_product = (int) $idProduct;
    $display->active = 1;
    $display->position = (int) $position;
    if (!$display->save()) {
        throw new RuntimeException('Could not select room '.$idProduct.' for the homepage');
    }
}

function limitHomepageToDemoProperties(array $demoProductIds)
{
    foreach ((array) Db::getInstance()->executeS('SELECT `id_room_block`, `id_product` FROM `'._DB_PREFIX_.'htl_room_block_data`') as $row) {
        if (in_array((int) $row['id_product'], $demoProductIds)) {
            continue;
        }
        $display = new WkHotelRoomDisplay((int) $row['id_room_block']);
        $display->active = 0;
        $display->save();
    }
}

/**
 * Keeps the four "Book with confidence" feature cards aligned with the
 * farmstay product. Content is fixed demo copy (en), re-synced on every run.
 */
function syncFeatureBlocks($idLang)
{
    $cards = array(
        array(
            'title' => 'Farmstay rooms',
            'description' => 'Veranda suites and orchard rooms with open skies, warm quilts and village mornings.',
        ),
        array(
            'title' => 'Home-style UP kitchen',
            'description' => 'Farm-fresh thalis and evening chai, cooked with produce from local fields and orchards.',
        ),
        array(
            'title' => 'Local experiences',
            'description' => 'Heritage walks, village looms and riverfront evenings, arranged by your hosts.',
        ),
        array(
            'title' => 'Clear, easy booking',
            'description' => 'Transparent prices, instant confirmation and local support during your stay.',
        ),
    );
    $languages = Language::getLanguages(false);
    $blocks = (array) Db::getInstance()->executeS(
        'SELECT `id_features_block`, `position` FROM `'._DB_PREFIX_.'htl_features_block_data` ORDER BY `position` ASC'
    );
    foreach ($cards as $index => $card) {
        if (!isset($blocks[$index])) {
            $obj = new WkHotelFeaturesData();
            $obj->position = (int) $index;
            $obj->active = 1;
            foreach ($languages as $language) {
                $obj->feature_title[$language['id_lang']] = $card['title'];
                $obj->feature_description[$language['id_lang']] = $card['description'];
            }
            if (!$obj->add()) {
                throw new RuntimeException('Could not create feature card '.$card['title']);
            }
            continue;
        }
        $obj = new WkHotelFeaturesData((int) $blocks[$index]['id_features_block']);
        $obj->active = 1;
        $obj->position = (int) $index;
        foreach ($languages as $language) {
            $obj->feature_title[$language['id_lang']] = $card['title'];
            $obj->feature_description[$language['id_lang']] = $card['description'];
        }
        if (!$obj->update()) {
            throw new RuntimeException('Could not update feature card '.$card['title']);
        }
    }
    foreach ((array) Db::getInstance()->executeS(
        'SELECT `id_features_block` FROM `'._DB_PREFIX_.'htl_features_block_data` ORDER BY `position` ASC'
    ) as $extra) {
        if (in_array((int) $extra['id_features_block'], array_map(function ($row) {
            return (int) $row['id_features_block'];
        }, $blocks))) {
            continue;
        }
        $obj = new WkHotelFeaturesData((int) $extra['id_features_block']);
        $obj->active = 0;
        $obj->update();
    }
    echo 'Feature cards synced.'.PHP_EOL;
}

/**
 * Give the demo fhblog posts covers from the theme editorial assets.
 *
 * Idempotent by default: covers are only written when a post has none.
 * Pass --refresh-images to re-copy and re-size every cover from source.
 *
 * @param int $idLang Language ID used to resolve post slugs.
 * @param bool $refreshImages Force re-copy of every cover.
 */
function syncStoryCovers($idLang, $refreshImages = false)
{
    $covers = array(
        'a-night-on-a-bundelkhand-farm' => 'story-night-farm.jpg',
        'village-guide-chanderi-weaving-country' => 'story-weaving.jpg',
        'five-farm-activities-you-can-actually-join' => 'story-ploughing.jpg',
        'understanding-ups-farm-stay-policy' => 'story-farmstay-policy.jpg',
    );
    $targetDir = _PS_IMG_DIR_.'fhblog';
    if (!is_dir($targetDir) && !@mkdir($targetDir, 0777, true)) {
        return;
    }
    foreach ($covers as $slug => $sourceFile) {
        $source = _PS_THEME_DIR_.'img/editorial/'.$sourceFile;
        if (!file_exists($source)) {
            continue;
        }
        $idPost = (int) Db::getInstance()->getValue(
            'SELECT p.`id_blog_post` FROM `'._DB_PREFIX_.'fhdiscover_blog_post` p '
            .'INNER JOIN `'._DB_PREFIX_.'fhdiscover_blog_post_lang` pl '
            .'ON pl.`id_blog_post` = p.`id_blog_post` AND pl.`id_lang` = '.(int) $idLang.' '
            .'WHERE pl.`slug` = "'.pSQL($slug).'"'
        );
        if (!$idPost) {
            continue;
        }
        $current = Db::getInstance()->getValue(
            'SELECT `cover` FROM `'._DB_PREFIX_.'fhdiscover_blog_post` WHERE `id_blog_post` = '.(int) $idPost
        );
        if ($current && !$refreshImages) {
            continue;
        }
        $target = $targetDir.'/'.$sourceFile;
        if ($refreshImages || !file_exists($target)) {
            if (!ImageManager::resize($source, $target, 1200, 675)) {
                continue;
            }
        }
        if ($current !== $sourceFile) {
            Db::getInstance()->update('fhdiscover_blog_post', array('cover' => pSQL($sourceFile)), '`id_blog_post` = '.(int) $idPost);
        }
    }
    echo 'Story covers synced.'.PHP_EOL;
}

/**
 * Create or refresh the "our-properties" CMS page used by header, footer and
 * region templates for the "All stays" destination.
 *
 * Content is rebuilt from the live demo hotels every run, so category links
 * stay in sync with the seeded inventory. Idempotent.
 *
 * @param int $idLang Language ID.
 */
function ensurePropertiesPage($idLang)
{
    $rewrite = 'our-properties';
    $idCms = (int) Db::getInstance()->getValue(
        'SELECT c.`id_cms` FROM `'._DB_PREFIX_.'cms` c '
        .'INNER JOIN `'._DB_PREFIX_.'cms_lang` cl ON cl.`id_cms` = c.`id_cms` '
        .'WHERE cl.`id_lang` = '.(int) $idLang.' AND cl.`link_rewrite` = "'.pSQL($rewrite).'"'
    );
    if (!$idCms) {
        $idCmsCategory = (int) Db::getInstance()->getValue(
            'SELECT `id_cms_category` FROM `'._DB_PREFIX_.'cms` ORDER BY `id_cms` ASC'
        );
        if (!$idCmsCategory) {
            return;
        }
        if (!Db::getInstance()->insert('cms', array('id_cms_category' => (int) $idCmsCategory, 'active' => 1, 'position' => 99))) {
            return;
        }
        $idCms = (int) Db::getInstance()->Insert_ID();
    }

    $rows = Db::getInstance()->executeS(
        'SELECT hb.`id`, hb.`id_category`, hbl.`hotel_name`, a.`city` '
        .'FROM `'._DB_PREFIX_.'htl_branch_info` hb '
        .'INNER JOIN `'._DB_PREFIX_.'htl_branch_info_lang` hbl ON hbl.`id` = hb.`id` AND hbl.`id_lang` = '.(int) $idLang.' '
        .'LEFT JOIN `'._DB_PREFIX_.'address` a ON a.`id_hotel` = hb.`id` AND a.`deleted` = 0 '
        .'WHERE hb.`active` = 1 ORDER BY hb.`id` ASC'
    );
    $items = array();
    foreach ($rows as $row) {
        if ((int) $row['id'] < 2) {
            continue;
        }
        $link = Context::getContext()->link->getCategoryLink(new Category((int) $row['id_category'], (int) $idLang));
        $items[] = '<li><a href="'.Tools::safeOutput($link).'">'.Tools::safeOutput($row['hotel_name']).'</a><span> — '.Tools::safeOutput($row['city']).'</span></li>';
    }
    $title = 'Our Properties | Rural UP';
    $content = '<h1>Our Properties</h1><p>Six demonstration farmstays across Uttar Pradesh, each with its own region story, rooms and rates. Every listing is demo content with representative imagery — replace with client-approved material before production.</p><ul>'.implode('', $items).'</ul><p><a href="'.Tools::safeOutput(Context::getContext()->link->getPageLink('index')).'">Back to search</a></p>';
    $langs = Language::getLanguages();
    foreach ($langs as $lang) {
        $exists = (int) Db::getInstance()->getValue(
            'SELECT COUNT(*) FROM `'._DB_PREFIX_.'cms_lang` WHERE `id_cms` = '.(int) $idCms.' AND `id_lang` = '.(int) $lang['id_lang']
        );
        $langData = array(
            'id_cms' => (int) $idCms,
            'id_lang' => (int) $lang['id_lang'],
            'meta_title' => pSQL('Our Properties | Rural UP'),
            'meta_description' => pSQL('Browse the Rural UP farmstay collection: six demo stays across Awadh, Bundelkhand, Braj, Purvanchal, Rohilkhand and Kashi.'),
            'meta_keywords' => '',
            'content' => pSQL($content),
            'link_rewrite' => pSQL($rewrite),
        );
        if ($exists) {
            unset($langData['id_cms'], $langData['id_lang']);
            Db::getInstance()->update('cms_lang', $langData, '`id_cms` = '.(int) $idCms.' AND `id_lang` = '.(int) $lang['id_lang']);
        } else {
            Db::getInstance()->insert('cms_lang', $langData);
        }
    }
    echo 'Properties page synced.'.PHP_EOL;
}
