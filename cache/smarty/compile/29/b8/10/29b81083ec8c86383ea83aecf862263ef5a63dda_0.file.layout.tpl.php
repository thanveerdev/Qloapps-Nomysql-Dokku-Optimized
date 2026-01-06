<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:00
  from '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/layout.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce03dab96_05718899',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '29b81083ec8c86383ea83aecf862263ef5a63dda' => 
    array (
      0 => '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/layout.tpl',
      1 => 1753273972,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:./alerts.tpl' => 1,
  ),
),false)) {
function content_69022ce03dab96_05718899 (Smarty_Internal_Template $_smarty_tpl) {
echo $_smarty_tpl->tpl_vars['header']->value;?>

<?php $_smarty_tpl->_subTemplateRender('file:./alerts.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
echo $_smarty_tpl->tpl_vars['page']->value;?>

<?php echo $_smarty_tpl->tpl_vars['footer']->value;?>

<?php }
}
