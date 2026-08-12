<?php
/**
 * Blog post administration controller.
 *
 * @license OSL-3.0
 */

/**
 * Manages editorial posts, covers and category assignments.
 */
class AdminFhBlogPostController extends ModuleAdminController
{
    /**
     * Configure the multilingual post CRUD list.
     */
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'fhdiscover_blog_post';
        $this->className = 'FhBlogPost';
        $this->identifier = 'id_blog_post';
        $this->lang = true;
        $this->context = Context::getContext();

        parent::__construct();

        $this->_select = ' pl.`title`, pl.`author`, cl.`name` AS category_name';
        $this->_join = ' LEFT JOIN `'._DB_PREFIX_.'fhdiscover_blog_post_lang` pl
            ON pl.`id_blog_post` = a.`id_blog_post` AND pl.`id_lang` = '.(int) $this->context->language->id;
        $this->_join .= ' LEFT JOIN `'._DB_PREFIX_.'fhdiscover_blog_category` c
            ON c.`id_blog_category` = a.`id_blog_category`';
        $this->_join .= ' LEFT JOIN `'._DB_PREFIX_.'fhdiscover_blog_category_lang` cl
            ON cl.`id_blog_category` = a.`id_blog_category` AND cl.`id_lang` = '.(int) $this->context->language->id;
        $this->_orderBy = 'date_add';
        $this->_orderWay = 'DESC';

        $this->fields_list = array(
            'id_blog_post' => array('title' => $this->l('ID'), 'class' => 'fixed-width-xs'),
            'title' => array('title' => $this->l('Title')),
            'category_name' => array('title' => $this->l('Category')),
            'author' => array('title' => $this->l('Author')),
            'date_add' => array('title' => $this->l('Published'), 'type' => 'datetime'),
            'active' => array('title' => $this->l('Enabled'), 'active' => 'status', 'type' => 'bool'),
        );
        $this->addRowAction('edit');
        $this->addRowAction('delete');
    }

    /**
     * Build the post form with category select and cover upload.
     *
     * @return string
     */
    public function renderForm()
    {
        $this->fields_form = array(
            'legend' => array('title' => $this->l('Farmstay story'), 'icon' => 'icon-pencil'),
            'input' => array(
                array('type' => 'text', 'label' => $this->l('Title'), 'name' => 'title', 'lang' => true, 'required' => true),
                array('type' => 'text', 'label' => $this->l('Slug'), 'name' => 'slug', 'lang' => true, 'required' => true, 'hint' => $this->l('URL-friendly name, lowercase with hyphens.')),
                array('type' => 'select', 'label' => $this->l('Category'), 'name' => 'id_blog_category', 'required' => true, 'options' => array('query' => FhBlogCategory::getList((int) $this->context->language->id), 'id' => 'id_blog_category', 'name' => 'name')),
                array('type' => 'file', 'label' => $this->l('Cover image'), 'name' => 'cover', 'display_image' => true, 'hint' => $this->l('Recommended: 1200x675 (16:9). Leave empty to use the themed placeholder.')),
                array('type' => 'textarea', 'label' => $this->l('Excerpt'), 'name' => 'excerpt', 'lang' => true, 'required' => true, 'autoload_rte' => false),
                array('type' => 'textarea', 'label' => $this->l('Content'), 'name' => 'content', 'lang' => true, 'autoload_rte' => true),
                array('type' => 'text', 'label' => $this->l('Author'), 'name' => 'author', 'lang' => true),
                array('type' => 'text', 'label' => $this->l('Meta title'), 'name' => 'meta_title', 'lang' => true),
                array('type' => 'text', 'label' => $this->l('Meta description'), 'name' => 'meta_description', 'lang' => true),
                array('type' => 'switch', 'label' => $this->l('Enabled'), 'name' => 'active', 'is_bool' => true, 'values' => array(array('id' => 'active_on', 'value' => 1, 'label' => $this->l('Yes')), array('id' => 'active_off', 'value' => 0, 'label' => $this->l('No')))),
            ),
            'submit' => array('title' => $this->l('Save')),
        );

        return parent::renderForm();
    }

    /**
     * Process the cover upload after saving the post.
     *
     * @return bool|object
     */
    public function postProcess()
    {
        $result = parent::postProcess();

        if (!empty($_FILES['cover']['tmp_name']) && isset($this->object) && Validate::isLoadedObject($this->object)) {
            $this->uploadCover($this->object);
        }

        return $result;
    }

    /**
     * Resize an uploaded image into the blog cover directory.
     *
     * @param FhBlogPost $object Post being saved.
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

            $fileName = 'post-'.(int) $object->id.'-'.date('YmdHis').'.'.strtolower($extension);
            $dest = _PS_IMG_.'fhblog'.DIRECTORY_SEPARATOR.$fileName;
            if (ImageManager::resize($_FILES['cover']['tmp_name'], $dest, 1200, 675)) {
                $object->cover = $fileName;
                if ($object->update()) {
                    $this->confirmations[] = $this->l('Cover image updated.');
                }
            }
        } else {
            $this->errors[] = $this->l('The cover image is invalid or too large (max 2 MB).');
        }
    }
}