<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:03:57
  from '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/helpers/modules_list/modal.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022cdd476679_61658320',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '44e8b32ee9b20a9b5c41326fb62bef37abd12909' => 
    array (
      0 => '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/helpers/modules_list/modal.tpl',
      1 => 1753273972,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022cdd476679_61658320 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="modal fade" id="modules_list_container">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h3 class="modal-title"><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Recommended Modules and Services'),$_smarty_tpl ) );?>
</h3>
			</div>
			<div class="modal-body">
				<div id="modules_list_container_tab_modal" style="display:none;"></div>
				<div id="modules_list_loader"><i class="icon-refresh icon-spin"></i></div>
			</div>
		</div>
	</div>
</div>
<?php }
}
