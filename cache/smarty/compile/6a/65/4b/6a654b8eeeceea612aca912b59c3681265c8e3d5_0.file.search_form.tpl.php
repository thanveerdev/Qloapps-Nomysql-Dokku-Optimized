<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:00
  from '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/search_form.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce03d2db8_54766278',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '6a654b8eeeceea612aca912b59c3681265c8e3d5' => 
    array (
      0 => '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/search_form.tpl',
      1 => 1753273972,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce03d2db8_54766278 (Smarty_Internal_Template $_smarty_tpl) {
?>
<form id="<?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['id']->value, ENT_QUOTES, 'UTF-8', true);?>
" class="bo_search_form" method="post" action="index.php?controller=AdminSearch&amp;token=<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['getAdminToken'][0], array( array('tab'=>'AdminSearch'),$_smarty_tpl ) );?>
" role="search">
	<div class="form-group">
		<input type="hidden" name="bo_search_type" id="bo_search_type" />
		<div class="input-group">
			<div class="input-group-btn">
				<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
					<i id="search_type_icon" class="icon-search"></i>
					<i class="icon-caret-down"></i>
				</button>
				<ul id="header_search_options" class="dropdown-menu">
					<li class="search-all search-option active">
						<a href="#" data-value="0" data-placeholder="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'What are you looking for?'),$_smarty_tpl ) );?>
" data-icon="icon-search">
							<i class="icon-search"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Everywhere'),$_smarty_tpl ) );?>
</a>
					</li>
					<li class="divider"></li>
					<li class="search-book search-option">
						<a href="#" data-value="<?php echo $_smarty_tpl->tpl_vars['QLO_SEARCH_TYPE_CATELOG']->value;?>
" data-placeholder="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Room Types, Service products...'),$_smarty_tpl ) );?>
" data-icon="icon-book">
							<i class="icon-book"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Catalog'),$_smarty_tpl ) );?>

						</a>
					</li>
					<li class="search-modules search-option">
						<a href="#" data-value="<?php echo $_smarty_tpl->tpl_vars['QLO_SEARCH_TYPE_HOTEL']->value;?>
" data-placeholder="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Hotel'),$_smarty_tpl ) );?>
" data-icon="icon-AdminHotelReservationSystemManagement">
							<i class="icon-building"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Hotel'),$_smarty_tpl ) );?>

						</a>
					</li>
					<li class="search-customers-name search-option">
						<a href="#" data-value="<?php echo $_smarty_tpl->tpl_vars['QLO_SEARCH_TYPE_CUSTOMER_BY_NAME']->value;?>
" data-placeholder="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Email, name...'),$_smarty_tpl ) );?>
" data-icon="icon-group">
							<i class="icon-group"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Customers'),$_smarty_tpl ) );?>
 <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'by name'),$_smarty_tpl ) );?>

						</a>
					</li>
					<li class="search-customers-addresses search-option">
						<a href="#" data-value="<?php echo $_smarty_tpl->tpl_vars['QLO_SEARCH_TYPE_CUSTOMER_BY_IP']->value;?>
" data-placeholder="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'123.45.67.89'),$_smarty_tpl ) );?>
" data-icon="icon-desktop">
							<i class="icon-desktop"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Customers'),$_smarty_tpl ) );?>
 <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'by ip address'),$_smarty_tpl ) );?>
</a>
					</li>
					<li class="search-orders search-option">
						<a href="#" data-value="<?php echo $_smarty_tpl->tpl_vars['QLO_SEARCH_TYPE_ORDER']->value;?>
" data-placeholder="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Order ID'),$_smarty_tpl ) );?>
" data-icon="icon-credit-card">
							<i class="icon-credit-card"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Orders'),$_smarty_tpl ) );?>

						</a>
					</li>
					<li class="search-invoices search-option">
						<a href="#" data-value="<?php echo $_smarty_tpl->tpl_vars['QLO_SEARCH_TYPE_INVOICE']->value;?>
" data-placeholder="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Invoice Number'),$_smarty_tpl ) );?>
" data-icon="icon-book">
							<i class="icon-file-text"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Invoices'),$_smarty_tpl ) );?>

						</a>
					</li>
					<li class="search-carts search-option">
						<a href="#" data-value="<?php echo $_smarty_tpl->tpl_vars['QLO_SEARCH_TYPE_CART']->value;?>
" data-placeholder="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Cart ID'),$_smarty_tpl ) );?>
" data-icon="icon-shopping-cart">
							<i class="icon-shopping-cart"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Carts'),$_smarty_tpl ) );?>

						</a>
					</li>
					<li class="search-modules search-option">
						<a href="#" data-value="<?php echo $_smarty_tpl->tpl_vars['QLO_SEARCH_TYPE_MODULE']->value;?>
" data-placeholder="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Module name'),$_smarty_tpl ) );?>
" data-icon="icon-puzzle-piece">
							<i class="icon-puzzle-piece"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Modules'),$_smarty_tpl ) );?>

						</a>
					</li>
				</ul>
			</div>
			<?php if ((isset($_smarty_tpl->tpl_vars['show_clear_btn']->value)) && $_smarty_tpl->tpl_vars['show_clear_btn']->value) {?>
			<a href="#" class="clear_search hide"><i class="icon-remove"></i></a>
			<?php }?>
			<input id="bo_query" name="bo_query" type="text" class="form-control" value="<?php echo $_smarty_tpl->tpl_vars['bo_query']->value;?>
" placeholder="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Search'),$_smarty_tpl ) );?>
" />
<!--  							<span class="input-group-btn">
				<button type="submit" id="bo_search_submit" class="btn btn-primary">
					<i class="icon-search"></i>
				</button>
			</span> -->
		</div>
	</div>

	<?php echo '<script'; ?>
>
		<?php if ((isset($_smarty_tpl->tpl_vars['search_type']->value)) && $_smarty_tpl->tpl_vars['search_type']->value) {?>
			$(document).ready(function() {
				$('.search-option a[data-value='+<?php echo intval($_smarty_tpl->tpl_vars['search_type']->value);?>
+']').click();
			});
		<?php }?>
	<?php echo '</script'; ?>
>
</form><?php }
}
