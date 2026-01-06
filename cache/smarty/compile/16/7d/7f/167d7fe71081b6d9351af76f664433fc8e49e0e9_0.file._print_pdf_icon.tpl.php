<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:03
  from '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/controllers/orders/_print_pdf_icon.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce3e64446_48073270',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '167d7fe71081b6d9351af76f664433fc8e49e0e9' => 
    array (
      0 => '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/controllers/orders/_print_pdf_icon.tpl',
      1 => 1753273972,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce3e64446_48073270 (Smarty_Internal_Template $_smarty_tpl) {
?>
<span class="btn-group-action">
	<span class="btn-group">
	<?php if (Configuration::get('PS_INVOICE') && $_smarty_tpl->tpl_vars['order']->value->invoice_number) {?>
		<a class="btn btn-default _blank" href="<?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['link']->value->getAdminLink('AdminPdf'), ENT_QUOTES, 'UTF-8', true);?>
&amp;submitAction=generateInvoicePDF&amp;id_order=<?php echo $_smarty_tpl->tpl_vars['order']->value->id;?>
">
			<i class="icon-file-text"></i>
		</a>
	<?php }?>
			</span>
</span>
<?php }
}
