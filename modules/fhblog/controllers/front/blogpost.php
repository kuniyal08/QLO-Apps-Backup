<?php
/**
 * Public single post controller.
 *
 * @license OSL-3.0
 */

/**
 * Displays one editorial post with related and adjacent posts.
 */
class FhblogBlogpostModuleFrontController extends ModuleFrontController
{
    /**
     * Prepare the post detail content.
     */
    public function initContent()
    {
        parent::initContent();

        $idPost = (int) Tools::getValue('id_blog_post');
        if (!Validate::isUnsignedId($idPost)) {
            Tools::redirect($this->context->link->getModuleLink($this->module->name, 'blog'));
        }

        $idLang = (int) $this->context->language->id;
        $post = new FhBlogPost($idPost, $idLang);
        if (!Validate::isLoadedObject($post) || !$post->active) {
            Tools::redirect($this->context->link->getModuleLink($this->module->name, 'blog'));
        }

        $category = new FhBlogCategory((int) $post->id_blog_category, $idLang);

        $this->context->smarty->assign(array(
            'fh_blog_post' => $post,
            'fh_blog_category' => Validate::isLoadedObject($category) ? $category : null,
            'fh_blog_related' => FhBlogPost::getRelated($idLang, $idPost, 3),
            'fh_blog_adjacent' => FhBlogPost::getAdjacent($idLang, $idPost, $post->date_add),
            'fh_blog_list_url' => $this->context->link->getModuleLink($this->module->name, 'blog'),
            'fh_blog_post_url' => $this->context->link->getModuleLink($this->module->name, 'blogpost'),
            'meta_title' => $post->meta_title ? $post->meta_title : $post->title,
            'meta_description' => $post->meta_description,
        ));

        $this->setTemplate('blogpost.tpl');
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
     * Load module styles on the post page.
     */
    public function setMedia()
    {
        parent::setMedia();
        $this->addCSS($this->module->getPathUri().'views/css/fhblog.css');
    }
}