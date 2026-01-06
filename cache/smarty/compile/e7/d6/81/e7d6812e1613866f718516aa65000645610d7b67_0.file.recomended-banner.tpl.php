<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:00
  from '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/recomended-banner.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce0385bc8_04657738',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'e7d6812e1613866f718516aa65000645610d7b67' => 
    array (
      0 => '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/recomended-banner.tpl',
      1 => 1753273972,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce0385bc8_04657738 (Smarty_Internal_Template $_smarty_tpl) {
?>
<div id="recommendation-wrapper-skeleton" style="display:none">
    <?php echo '<script'; ?>
>
        loadRecommendation();
    <?php echo '</script'; ?>
>
    <div class="col-sm-12">
        <div class="banner panel">
            <div class="row">
                <div class="col-sm-12">
                    <div class="skeleton-loading-pulse loading-container-bar"></div>
                    <div class="loading-container-bar"></div>
                    <div class="skeleton-loading-pulse loading-container-bar"></div>
                    <div class="loading-container-bar"></div>
                    <div class="skeleton-loading-pulse loading-container-bar"></div>
                    <div class="loading-container-bar"></div>
                    <div class="skeleton-loading-pulse loading-container-bar"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="recommendation-wrapper" style="display:none">
</div><?php }
}
