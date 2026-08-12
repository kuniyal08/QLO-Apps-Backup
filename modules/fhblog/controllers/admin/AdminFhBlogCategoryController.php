<?php
/**
 * Blog category administration controller.
 *
 * @license OSL-3.0
 */

/**
 * Manages the editorial category taxonomy.
 */
class AdminFhBlogCategoryController extends ModuleAdminController
{
    /**
     * Configure the multilingual category CRUD list.
     */
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'fhdiscover_blog_category';
        $this->className = 'FhBlogCategory';
        $this->identifier = 'id_blog_category';
        $this->lang = true;
        $this->context = Context::getContext();

        parent::__construct();

        $this->_select = ' cl.`name`';
        $this->_join = ' LEFT JOIN `'._DB_PREFIX_.'fhdiscover_blog_category_lang` cl
            ON cl.`id_blog_category` = a.`id_blog_category` AND cl.`id_lang` = '.(int) $this->context->language->id;
        $this->_orderBy = 'position';
        $this->_orderWay = 'ASC';

        $this->fields_list = array(
            'id_blog_category' => array('title' => $this->l('ID'), 'class' => 'fixed-width-xs'),
            'name' => array('title' => $this->l('Category')),
            'position' => array('title' => $this->l('Position'), 'class' => 'fixed-width-xs'),
            'active' => array('title' => $this->l('Enabled'), 'active' => 'status', 'type' => 'bool'),
        );
        $this->addRowAction('edit');
        $this->addRowAction('delete');
    }

    /**
     * Build the category form.
     *
     * @return string
     */
    public function renderForm()
    {
        $this->fields_form = array(
            'legend' => array('title' => $this->l('Story category'), 'icon' => 'icon-tags'),
            'input' => array(
                array('type' => 'text', 'label' => $this->l('Category name'), 'name' => 'name', 'lang' => true, 'required' => true),
                array('type' => 'text', 'label' => $this->l('Display position'), 'name' => 'position', 'class' => 'fixed-width-xs'),
                array('type' => 'switch', 'label' => $this->l('Enabled'), 'name' => 'active', 'is_bool' => true, 'values' => array(array('id' => 'active_on', 'value' => 1, 'label' => $this->l('Yes')), array('id' => 'active_off', 'value' => 0, 'label' => $this->l('No')))),
            ),
            'submit' => array('title' => $this->l('Save')),
        );

        return parent::renderForm();
    }
}