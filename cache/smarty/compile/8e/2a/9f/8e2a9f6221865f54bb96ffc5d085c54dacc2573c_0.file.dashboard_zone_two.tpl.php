<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:00
  from '/home/qloapps/www/QloApps/modules/dashproducts/views/templates/hook/dashboard_zone_two.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce0334528_82164863',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '8e2a9f6221865f54bb96ffc5d085c54dacc2573c' => 
    array (
      0 => '/home/qloapps/www/QloApps/modules/dashproducts/views/templates/hook/dashboard_zone_two.tpl',
      1 => 1753273976,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce0334528_82164863 (Smarty_Internal_Template $_smarty_tpl) {
?>
<div class="col-sm-12">
	<section id="dashproducts" class="panel widget <?php if ($_smarty_tpl->tpl_vars['allow_push']->value) {?> allow_push<?php }?>">
		<header class="panel-heading">
			<i class="icon-bar-chart"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Sales','mod'=>'dashproducts'),$_smarty_tpl ) );?>

			<span class="panel-heading-action">
				<a class="list-toolbar-btn" href="#" onclick="toggleDashConfig('dashproducts'); return false;" title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Configure",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
">
					<i class="process-icon-configure"></i>
				</a>
				<a class="list-toolbar-btn" href="#"  onclick="refreshDashboard('dashproducts'); return false;"  title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Refresh",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
">
					<i class="process-icon-refresh"></i>
				</a>
			</span>
		</header>

		<section id="dashproducts_config" class="dash_config hide">
			<header><i class="icon-wrench"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Configuration','mod'=>'dashproducts'),$_smarty_tpl ) );?>
</header>
			<?php echo $_smarty_tpl->tpl_vars['dashproducts_config_form']->value;?>

		</section>

		<section>
			<nav>
				<ul class="nav nav-pills row">
					<li class="col-xs-6 col-sm-3 nav-item active">
						<a href="#dash_recent_orders" data-toggle="tab">
							<span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"New Bookings",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
</span>
						</a>
					</li>
					<li class="col-xs-6 col-sm-3 nav-item">
						<a href="#dash_best_sellers" data-toggle="tab">
							<span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Best Selling",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
</span>
						</a>
					</li>
					<li class="col-xs-6 col-sm-3 nav-item">
						<a href="#dash_most_viewed" data-toggle="tab">
							<span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Most Viewed",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
</span>
						</a>
					</li>
					<li class="col-xs-6 col-sm-3 nav-item">
						<a href="#dash_top_search" data-toggle="tab">
							<span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Top Searches",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
</span>
						</a>
					</li>
				</ul>
			</nav>

			<div class="tab-content panel">
				<div class="tab-pane active" id="dash_recent_orders">
					<h3><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Last %d bookings",'sprintf'=>intval($_smarty_tpl->tpl_vars['DASHPRODUCT_NBR_SHOW_LAST_ORDER']->value),'mod'=>'dashproducts'),$_smarty_tpl ) );?>
</h3>
					<div class="table-responsive">
						<table class="table data_table" id="table_recent_orders">
							<thead></thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
				<div class="tab-pane" id="dash_best_sellers">
					<h3>
						<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Top %d room types",'sprintf'=>intval($_smarty_tpl->tpl_vars['DASHPRODUCT_NBR_SHOW_BEST_SELLER']->value),'mod'=>'dashproducts'),$_smarty_tpl ) );?>
 (<span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"From",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
 <?php echo $_smarty_tpl->tpl_vars['date_from']->value;?>
 <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"to",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
 <?php echo $_smarty_tpl->tpl_vars['date_to']->value;?>
</span>)
					</h3>
					<div class="table-responsive">
						<table class="table data_table" id="table_best_sellers">
							<thead></thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
				<div class="tab-pane" id="dash_most_viewed">
					<h3>
						<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Most viewed room types",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
 (<span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"From",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
 <?php echo $_smarty_tpl->tpl_vars['date_from']->value;?>
 <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"to",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
 <?php echo $_smarty_tpl->tpl_vars['date_to']->value;?>
</span>)
					</h3>
					<div class="table-responsive">
						<table class="table data_table" id="table_most_viewed">
							<thead></thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
				<div class="tab-pane" id="dash_top_search">
					<h3>
						<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Top %d most searched hotels",'sprintf'=>intval($_smarty_tpl->tpl_vars['DASHPRODUCT_NBR_SHOW_TOP_SEARCH']->value),'mod'=>'dashproducts'),$_smarty_tpl ) );?>
 (<span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"From",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
 <?php echo $_smarty_tpl->tpl_vars['date_from']->value;?>
 <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"to",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
 <?php echo $_smarty_tpl->tpl_vars['date_to']->value;?>
</span>)
					</h3>
                    <div class="alert alert-info"><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Top searched hotel list is independent of hotel selection at the top. It will always display top searched hotels among all hotels.",'mod'=>'dashproducts'),$_smarty_tpl ) );?>
</div>
					<div class="table-responsive">
						<table class="table data_table" id="table_top_10_most_search">
							<thead></thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
			</div>
		</section>
	</section>
</div>
<div class="clearfix"></div>
<?php }
}
