<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:03
  from '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/helpers/kpi/row.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce3d77381_30899881',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '1041b059f5f5f02939522b102dc6be7f5dc4a37d' => 
    array (
      0 => '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/helpers/kpi/row.tpl',
      1 => 1753273972,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce3d77381_30899881 (Smarty_Internal_Template $_smarty_tpl) {
?>
<div class="panel kpi-container<?php if ((isset($_smarty_tpl->tpl_vars['no_wrapping']->value)) && $_smarty_tpl->tpl_vars['no_wrapping']->value) {?> no-wrapping<?php }?>">
	<div class="kpis-wrap">
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['kpis']->value, 'kpi');
$_smarty_tpl->tpl_vars['kpi']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['kpi']->value) {
$_smarty_tpl->tpl_vars['kpi']->do_else = false;
?>
			<div class="kpi-wrap"<?php if ((isset($_smarty_tpl->tpl_vars['kpi']->value->visible)) && !$_smarty_tpl->tpl_vars['kpi']->value->visible) {?>style="display: none;"<?php }?>>
				<?php echo $_smarty_tpl->tpl_vars['kpi']->value->generate();?>

			</div>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
	</div>

	<div class="actions-wrap">
		<?php if ($_smarty_tpl->tpl_vars['refresh']->value) {?>
			<button class="btn btn-default" type="button" onclick="refresh_kpis();" title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Refresh'),$_smarty_tpl ) );?>
">
				<i class="icon-refresh"></i>
			</button>
		<?php }?>

		<div class="dropdown">
			<button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown" title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Select KPIs'),$_smarty_tpl ) );?>
">
				<i class="icon-ellipsis-vertical"></i>
			</button>

			<ul class="dropdown-menu">
				<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['kpis']->value, 'kpi');
$_smarty_tpl->tpl_vars['kpi']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['kpi']->value) {
$_smarty_tpl->tpl_vars['kpi']->do_else = false;
?>
					<li>
						<label>
							<input type="checkbox" class="kpi-display-toggle" data-kpi-id="<?php echo $_smarty_tpl->tpl_vars['kpi']->value->id;?>
" <?php if ($_smarty_tpl->tpl_vars['kpi']->value->visible) {?>checked <?php if ($_smarty_tpl->tpl_vars['count_visible']->value == 1) {?>disabled<?php }
}?>>
							<?php echo $_smarty_tpl->tpl_vars['kpi']->value->title;?>

						</label>
					</li>
				<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
			</ul>
		</div>

		<button class="btn btn-default" type="button" onclick="toggleKpiView();" title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Toggle View'),$_smarty_tpl ) );?>
">
			<i class="icon-retweet"></i>
		</button>
	</div>
</div>
<?php }
}
