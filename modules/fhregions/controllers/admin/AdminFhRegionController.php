<?php
/**
 * Region administration controller.
 *
 * @license OSL-3.0
 */

/**
 * Manages regions, their cover images and their discovery links.
 */
class AdminFhRegionController extends ModuleAdminController
{
    /** @var array */
    private $hotels = array();

    /** @var array */
    private $activities = array();

    /**
     * Configure the multilingual region CRUD list.
     */
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'fhdiscover_region';
        $this->className = 'FhRegion';
        $this->identifier = 'id_region';
        $this->lang = true;
        $this->context = Context::getContext();

        parent::__construct();

        $this->_select = ' frl.`name`';
        $this->_join = ' LEFT JOIN `'._DB_PREFIX_.'fhdiscover_region_lang` frl
            ON frl.`id_region` = a.`id_region` AND frl.`id_lang` = '.(int) $this->context->language->id;
        $this->_orderBy = 'position';
        $this->_orderWay = 'ASC';

        $this->fields_list = array(
            'id_region' => array('title' => $this->l('ID'), 'class' => 'fixed-width-xs'),
            'name' => array('title' => $this->l('Region')),
            'position' => array('title' => $this->l('Position'), 'class' => 'fixed-width-xs'),
            'active' => array('title' => $this->l('Enabled'), 'active' => 'status', 'type' => 'bool'),
        );
        $this->addRowAction('edit');
        $this->addRowAction('delete');
    }

    /**
     * Build the region form with cover upload and discovery links.
     *
     * @return string
     */
    public function renderForm()
    {
        $this->hotels = $this->getHotels();
        $this->activities = $this->getActivities();

        $this->fields_form = array(
            'legend' => array('title' => $this->l('UP region'), 'icon' => 'icon-map-marker'),
            'input' => array(
                array('type' => 'text', 'label' => $this->l('Region name'), 'name' => 'name', 'lang' => true, 'required' => true),
                array('type' => 'textarea', 'label' => $this->l('Short blurb'), 'name' => 'blurb', 'lang' => true, 'required' => true, 'autoload_rte' => false),
                array('type' => 'textarea', 'label' => $this->l('Full description'), 'name' => 'description', 'lang' => true, 'autoload_rte' => true),
                array('type' => 'file', 'label' => $this->l('Cover image'), 'name' => 'cover', 'display_image' => true, 'hint' => $this->l('Recommended: 1600x900 (16:9). Leave empty to use the themed placeholder.')),
                array('type' => 'checkbox', 'label' => $this->l('Properties in this region'), 'name' => 'hotels', 'values' => array('query' => $this->hotels, 'id' => 'id', 'name' => 'name', 'default' => '')),
                array('type' => 'checkbox', 'label' => $this->l('Activities in this region'), 'name' => 'activities', 'values' => array('query' => $this->activities, 'id' => 'id', 'name' => 'name', 'default' => '')),
                array('type' => 'text', 'label' => $this->l('Display position'), 'name' => 'position', 'class' => 'fixed-width-xs'),
                array('type' => 'switch', 'label' => $this->l('Enabled'), 'name' => 'active', 'is_bool' => true, 'values' => array(array('id' => 'active_on', 'value' => 1, 'label' => $this->l('Yes')), array('id' => 'active_off', 'value' => 0, 'label' => $this->l('No')))),
            ),
            'submit' => array('title' => $this->l('Save')),
        );

        return parent::renderForm();
    }

    /**
     * Assign the current links to the form and process the cover upload.
     *
     * @return bool|object
     */
    public function postProcess()
    {
        $idRegion = (int) Tools::getValue('id_region');
        if ($idRegion && Validate::isUnsignedId($idRegion)) {
            $this->fields_value['hotels'] = FhRegion::getHotelIds($idRegion);
            $this->fields_value['activities'] = FhRegion::getActivityIds($idRegion);
        }

        $result = parent::postProcess();

        if (!empty($_FILES['cover']['tmp_name']) && isset($this->object) && Validate::isLoadedObject($this->object)) {
            $this->uploadCover($this->object);
        }

        if (isset($this->object) && Validate::isLoadedObject($this->object)) {
            $hotelIds = array();
            foreach ((array) Tools::getValue('hotels') as $id) {
                if (Validate::isUnsignedId($id)) {
                    $hotelIds[] = (int) $id;
                }
            }
            $activityIds = array();
            foreach ((array) Tools::getValue('activities') as $id) {
                if (Validate::isUnsignedId($id)) {
                    $activityIds[] = (int) $id;
                }
            }
            FhRegion::setHotelIds((int) $this->object->id, $hotelIds);
            FhRegion::setActivityIds((int) $this->object->id, $activityIds);
        }

        return $result;
    }

    /**
     * Resize an uploaded image into the region cover directory.
     *
     * @param FhRegion $object Region being saved.
     *
     * @return void
     */
    private function uploadCover($object)
    {
        if (!ImageManager::validateUpload($_FILES['cover'], 2097152)) {
            $extension = pathinfo($_FILES['cover']['name'], PATHINFO_EXTENSION);
            if (!in_array(strtolower($extension), array('jpg', 'jpeg', 'png', 'webp'))) {
                $extension = 'jpg';
            }

            $fileName = 'region-'.(int) $object->id.'-'.date('YmdHis').'.'.strtolower($extension);
            $dest = _PS_IMG_.'fhregions'.DIRECTORY_SEPARATOR.$fileName;
            if (ImageManager::resize($_FILES['cover']['tmp_name'], $dest, 1600, 900)) {
                $object->cover = $fileName;
                if ($object->update()) {
                    $this->confirmations[] = $this->l('Cover image updated.');
                }
            }
        } else {
            $this->errors[] = $this->l('The cover image is invalid or too large (max 2 MB).');
        }
    }

    /**
     * Get the active properties for the link checkboxes.
     *
     * @return array
     */
    private function getHotels()
    {
        $hotels = (new HotelBranchInformation())->hotelBranchesInfo((int) $this->context->language->id, 1, 0);
        $result = array();
        foreach ((array) $hotels as $hotel) {
            $result[] = array('id' => (int) $hotel['id'], 'name' => $hotel['hotel_name']);
        }

        return $result;
    }

    /**
     * Get the existing activities for the link checkboxes.
     *
     * @return array
     */
    private function getActivities()
    {
        if (!Module::isInstalled('ruralactivities') || !Module::isEnabled('ruralactivities')) {
            return array();
        }

        $activities = Db::getInstance()->executeS(
            'SELECT ra.`id_rural_activity`, ra.`id_hotel`, ral.`name`, hbl.`hotel_name`
            FROM `'._DB_PREFIX_.'rural_activity` ra
            INNER JOIN `'._DB_PREFIX_.'rural_activity_lang` ral
                ON ral.`id_rural_activity` = ra.`id_rural_activity`
                AND ral.`id_lang` = '.(int) $this->context->language->id.'
            LEFT JOIN `'._DB_PREFIX_.'htl_branch_info_lang` hbl
                ON hbl.`id` = ra.`id_hotel` AND hbl.`id_lang` = '.(int) $this->context->language->id.'
            ORDER BY ra.`position` ASC, ra.`id_rural_activity` ASC'
        );

        $result = array();
        foreach ((array) $activities as $activity) {
            $label = $activity['name'];
            if (!empty($activity['hotel_name'])) {
                $label .= ' — '.$activity['hotel_name'];
            }
            $result[] = array('id' => (int) $activity['id_rural_activity'], 'name' => $label);
        }

        return $result;
    }
}