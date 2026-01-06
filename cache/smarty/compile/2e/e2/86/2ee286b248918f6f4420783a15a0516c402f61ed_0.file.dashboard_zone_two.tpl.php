<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:00
  from '/home/qloapps/www/QloApps/modules/dashtrends/views/templates/hook/dashboard_zone_two.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce030e144_85353447',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '2ee286b248918f6f4420783a15a0516c402f61ed' => 
    array (
      0 => '/home/qloapps/www/QloApps/modules/dashtrends/views/templates/hook/dashboard_zone_two.tpl',
      1 => 1753273976,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce030e144_85353447 (Smarty_Internal_Template $_smarty_tpl) {
?>
<div class='clearfix'></div>

<div class='col-sm-12'>
	<?php echo '<script'; ?>
>
		var currency_format = <?php echo floatval($_smarty_tpl->tpl_vars['currency']->value->format);?>
;
		var currency_sign = '<?php echo addcslashes($_smarty_tpl->tpl_vars['currency']->value->sign,'\'');?>
';
		var currency_blank = <?php echo intval($_smarty_tpl->tpl_vars['currency']->value->blank);?>
;
		var priceDisplayPrecision = <?php echo intval($_smarty_tpl->tpl_vars['_PS_PRICE_DISPLAY_PRECISION_']->value);?>
;
	<?php echo '</script'; ?>
>

	<section id="dashtrends" class="panel widget<?php if ($_smarty_tpl->tpl_vars['allow_push']->value) {?> allow_push<?php }?>">
		<header class="panel-heading">
			<i class="icon-bar-chart"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Revenue','mod'=>'dashtrends'),$_smarty_tpl ) );?>

			<span class="panel-heading-action">
				<a class="list-toolbar-btn" href="<?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['link']->value->getAdminLink('AdminDashboard'), ENT_QUOTES, 'UTF-8', true);?>
&amp;profitability_conf=1" title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Configure','mod'=>'dashtrends'),$_smarty_tpl ) );?>
">
					<i class="process-icon-configure"></i>
				</a>
				<a class="list-toolbar-btn" href="#" onclick="refreshDashboard('dashtrends'); return false;" title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Refresh','mod'=>'dashtrends'),$_smarty_tpl ) );?>
">
					<i class="process-icon-refresh"></i>
				</a>
			</span>
		</header>
		<section id="dashtrends_toolbar">
			<div class="col-md-4 col-xs-6">
				<dl class="label-tooltip" onclick="selectDashtrendsChart(this, 'sales');" data-toggle="tooltip" data-placement="top" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Sum of revenue (excluding tax) generated within the date range by orders considered validated.','mod'=>'dashtrends'),$_smarty_tpl ) );?>
" data-placement="bottom" style='background-color: #72C3F0;'>
					<dt><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Sales','mod'=>'dashtrends'),$_smarty_tpl ) );?>
</dt>
					<dd class="data_value size_l"><span id="sales_score"></span></dd>
				</dl>
			</div>
			<div class="col-md-4 col-xs-6">
				<dl class="label-tooltip" onclick="selectDashtrendsChart(this, 'orders');" data-toggle="tooltip" data-placement="top" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Total number of orders received within the date range that are considered validated.','mod'=>'dashtrends'),$_smarty_tpl ) );?>
" data-placement="bottom" style='background-color: #56CE56;'>
					<dt><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Orders','mod'=>'dashtrends'),$_smarty_tpl ) );?>
</dt>
					<dd class="data_value size_l"><span id="orders_score"></span></dd>
				</dl>
			</div>
			<div class="col-md-4 col-xs-6">
				<dl class="label-tooltip" onclick="selectDashtrendsChart(this, 'average_cart_value');" data-toggle="tooltip" data-placement="top" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Average Order Value is a metric representing the value of an average order within the date range. It is calculated by dividing sales by bookings. This data is provided by the module "Data mining for statistics", so please make sure it is installed and configured.','mod'=>'dashtrends'),$_smarty_tpl ) );?>
" data-placement="bottom" style='background-color: #FF655C;'>
					<dt><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Average Order Value','mod'=>'dashtrends'),$_smarty_tpl ) );?>
</dt>
					<dd class="data_value size_l"><span id="cart_value_score"></span></dd>
				</dl>
			</div>
			<div class="col-md-4 col-xs-6">
				<dl class="label-tooltip" onclick="selectDashtrendsChart(this, 'visits');" data-toggle="tooltip" data-placement="top" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Total number of visits within the date range. A visit is the period of time a user is actively engaged with your website. This data is provided by the module "Data mining for statistics", so please make sure it is installed and configured.','mod'=>'dashtrends'),$_smarty_tpl ) );?>
" data-placement="bottom" style='background-color: #FF7F0E;'>
					<dt><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Visits','mod'=>'dashtrends'),$_smarty_tpl ) );?>
</dt>
					<dd class="data_value size_l"><span id="visits_score"></span></dd>
				</dl>
			</div>
			<div class="col-md-4 col-xs-6">
				<dl class="label-tooltip" onclick="selectDashtrendsChart(this, 'conversion_rate');" data-toggle="tooltip" data-placement="top" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Conversion Rate is the percentage of visits that resulted in a validated booking.','mod'=>'dashtrends'),$_smarty_tpl ) );?>
" data-placement="bottom" style="background-color: #A569DF;">
					<dt><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Conversion Rate','mod'=>'dashtrends'),$_smarty_tpl ) );?>
</dt>
					<dd class="data_value size_l"><span id="conversion_rate_score"></span></dd>
				</dl>
			</div>
			<div class="col-md-4 col-xs-6">
				<dl class="label-tooltip" onclick="selectDashtrendsChart(this, 'net_profits');" data-toggle="tooltip" data-placement="top" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Net Profit is the amount of money earned after deducting all operating costs and expenses over a period of time. You can provide these costs by clicking on the configuration icon right above here.','mod'=>'dashtrends'),$_smarty_tpl ) );?>
" data-placement="bottom" style="background-color: #AF8A42;">
					<dt><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Net Profit','mod'=>'dashtrends'),$_smarty_tpl ) );?>
</dt>
					<dd class="data_value size_l"><span id="net_profits_score"></span></dd>
				</dl>
			</div>
		</section>
		<div id="dash_trends_chart1" class="chart with-transitions">
			<svg></svg>
		</div>
		<div class='clearfix'></div>
	</section>
</div>
<div class='clearfix'></div>
<?php }
}
