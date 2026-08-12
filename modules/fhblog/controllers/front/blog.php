<?php
/**
 * Public stories listing controller.
 *
 * @license OSL-3.0
 */

/**
 * Displays paginated editorial posts with a category filter.
 */
class FhblogBlogModuleFrontController extends ModuleFrontController
{
    /** @var int */
    private $perPage = 9;

    /**
     * Prepare paginated blog content.
     */
    public function initContent()
    {
        parent::initContent();

        $idCategory = (int) Tools::getValue('id_blog_category');
        if ($idCategory && !Validate::isUnsignedId($idCategory)) {
            $idCategory = 0;
        }

        $page = max(1, (int) Tools::getValue('page', 1));
        $idLang = (int) $this->context->language->id;

        $total = FhBlogPost::countActive($idCategory);
        $pageCount = max(1, (int) ceil($total / $this->perPage));
        $page = min($page, $pageCount);

        $posts = FhBlogPost::getPage($idLang, $idCategory, $page, $this->perPage);
        $postUrl = $this->context->link->getModuleLink($this->module->name, 'blogpost');

        $this->context->smarty->assign(array(
            'fh_blog_posts' => $posts,
            'fh_blog_categories' => FhBlogCategory::getList($idLang),
            'fh_blog_selected_category' => $idCategory,
            'fh_blog_post_url' => $postUrl,
            'fh_blog_page' => $page,
            'fh_blog_page_count' => $pageCount,
            'fh_blog_url' => $this->context->link->getModuleLink($this->module->name, 'blog'),
        ));

        $this->setTemplate('blog.tpl');
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
     * Load module styles on the listing page.
     */
    public function setMedia()
    {
        parent::setMedia();
        $this->addCSS($this->module->getPathUri().'views/css/fhblog.css');
    }
}