<?php
/**
 * Rural activity administration controller.
 *
 * @license AFL-3.0
 */

/**
 * Restricts activity administration to properties accessible to the employee.
 */
class AdminRuralActivitiesController extends ModuleAdminController
{
    /** @var array */
    private $hotels = array();

    /**
     * Configure the multilingual activity CRUD list.
     */
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'rural_activity';
        $this->className = 'RuralActivity';
        $this->identifier = 'id_rural_activity';
        $this->lang = true;
        $this->context = Context::getContext();

        $accessibleHotels = HotelBranchInformation::getProfileAccessedHotels(
            (int) $this->context->employee->id_profile,
            1,
            1
        );
        $accessibleHotels = array_map('intval', (array) $accessibleHotels);
        $this->access_select = 'SELECT a.`id_rural_activity` FROM `'._DB_PREFIX_.'rural_activity` a';
        $this->access_where = $accessibleHotels
            ? ' WHERE a.`id_hotel` IN ('.implode(',', $accessibleHotels).')'
            : ' WHERE 1 = 0';

        parent::__construct();

        $this->_select = ' hbl.`hotel_name`, ral.`name`, ral.`category`';
        $this->_join = ' LEFT JOIN `'._DB_PREFIX_.'htl_branch_info_lang` hbl
            ON hbl.`id` = a.`id_hotel` AND hbl.`id_lang` = '.(int) $this->context->language->id;
        $this->_join .= ' LEFT JOIN `'._DB_PREFIX_.'rural_activity_lang` ral
            ON ral.`id_rural_activity` = a.`id_rural_activity` AND ral.`id_lang` = '.(int) $this->context->language->id;
        $this->_orderBy = 'position';
        $this->_orderWay = 'ASC';

        $this->fields_list = array(
            'id_rural_activity' => array('title' => $this->l('ID'), 'class' => 'fixed-width-xs'),
            'name' => array('title' => $this->l('Activity')),
            'hotel_name' => array('title' => $this->l('Property')),
            'category' => array('title' => $this->l('Category')),
            'position' => array('title' => $this->l('Position'), 'class' => 'fixed-width-xs'),
            'active' => array('title' => $this->l('Enabled'), 'active' => 'status', 'type' => 'bool'),
        );
        $this->addRowAction('edit');
        $this->addRowAction('delete');
    }

    /**
     * Build the property list and activity fields.
     *
     * @return array
     */
    public function renderForm()
    {
        $this->hotels = $this->getAccessibleHotels();
        $this->fields_form = array(
            'legend' => array('title' => $this->l('Local activity'), 'icon' => 'icon-leaf'),
            'input' => array(
                array('type' => 'select', 'label' => $this->l('Property'), 'name' => 'id_hotel', 'required' => true, 'options' => array('query' => $this->hotels, 'id' => 'id', 'name' => 'name')),
                array('type' => 'text', 'label' => $this->l('Activity name'), 'name' => 'name', 'lang' => true, 'required' => true),
                array('type' => 'text', 'label' => $this->l('Category'), 'name' => 'category', 'lang' => true),
                array('type' => 'text', 'label' => $this->l('Typical duration'), 'name' => 'typical_duration', 'lang' => true),
                array('type' => 'text', 'label' => $this->l('Season or timing notes'), 'name' => 'season_notes', 'lang' => true),
                array('type' => 'textarea', 'label' => $this->l('Short description'), 'name' => 'short_description', 'lang' => true, 'required' => true, 'autoload_rte' => false),
                array('type' => 'textarea', 'label' => $this->l('Full description'), 'name' => 'description', 'lang' => true, 'autoload_rte' => true),
                array('type' => 'text', 'label' => $this->l('Display position'), 'name' => 'position', 'class' => 'fixed-width-xs'),
                array('type' => 'switch', 'label' => $this->l('Enabled'), 'name' => 'active', 'is_bool' => true, 'values' => array(array('id' => 'active_on', 'value' => 1, 'label' => $this->l('Yes')), array('id' => 'active_off', 'value' => 0, 'label' => $this->l('No')))),
            ),
            'submit' => array('title' => $this->l('Save')),
        );

        return parent::renderForm();
    }

    /**
     * Reject property IDs that the current employee cannot manage.
     *
     * @return bool
     */
    public function postProcess()
    {
        $idHotel = (int) Tools::getValue('id_hotel');
        if ((Tools::isSubmit('submitAdd'.$this->table) || Tools::isSubmit('submitAdd'.$this->table.'AndStay'))
            && (!Validate::isUnsignedId($idHotel) || !in_array($idHotel, array_column($this->getAccessibleHotels(), 'id')))
        ) {
            $this->errors[] = $this->l('You do not have permission to manage this property.');
        }

        return parent::postProcess();
    }

    /**
     * Get properties available to the current employee.
     *
     * @return array
     */
    private function getAccessibleHotels()
    {
        $allowedIds = array_map('intval', (array) HotelBranchInformation::getProfileAccessedHotels(
            (int) $this->context->employee->id_profile,
            1,
            1
        ));
        $hotels = (new HotelBranchInformation())->hotelBranchesInfo((int) $this->context->language->id, 1, 0);
        $result = array();

        foreach ((array) $hotels as $hotel) {
            if (in_array((int) $hotel['id'], $allowedIds)) {
                $result[] = array('id' => (int) $hotel['id'], 'name' => $hotel['hotel_name']);
            }
        }

        return $result;
    }
}
