<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:00
  from '/home/qloapps/www/QloApps/modules/dashperformance/views/templates/hook/dashboard_zone_two.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce031c382_03363144',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'ba2833a156db402ba89b5be986ffb468b7fdc79d' => 
    array (
      0 => '/home/qloapps/www/QloApps/modules/dashperformance/views/templates/hook/dashboard_zone_two.tpl',
      1 => 1753273976,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce031c382_03363144 (Smarty_Internal_Template $_smarty_tpl) {
?>
<div class="col-sm-12">
	<section id="dashperformance" class="panel widget <?php if ($_smarty_tpl->tpl_vars['allow_push']->value) {?> allow_push<?php }?>">
		<header class="panel-heading">
			<i class="icon-bar-chart"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Performance','mod'=>'dashperformance'),$_smarty_tpl ) );?>
 <small class="text-muted"><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'(Amounts are tax exclusive)','mod'=>'dashperformance'),$_smarty_tpl ) );?>
</small>
			<span class="panel-heading-action">
				<a class="list-toolbar-btn" href="#" onclick="refreshDashboard('dashperformance'); return false;" title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Refresh','mod'=>'dashperformance'),$_smarty_tpl ) );?>
">
					<i class="process-icon-refresh"></i>
				</a>
			</span>
		</header>
		<section>
			<div class="row stats-wrap">
				<div class="col-xs-6 col-lg-3">
					<div class="stat-box label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Average Daily Rate (ADR) represents the average rental income per occupied room over a given time period.','mod'=>'dashperformance'),$_smarty_tpl ) );?>
" data-placement="top" style="background-color: #B7F0FF;">
						<div class="title-wrapper">
							<p><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Average Daily Rate','mod'=>'dashperformance'),$_smarty_tpl ) );?>
</p>
						</div>
						<div class="value-wrapper">
							<span id="dp_average_daily_rate" style="color: #0093BA;">--</span>
						</div>
					</div>
				</div>
                <div class="col-xs-6 col-lg-3">
					<div class="stat-box label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Average Occupancy Rate (AOR) is the average percentage of rooms booked out over a given time period.','mod'=>'dashperformance'),$_smarty_tpl ) );?>
" data-placement="top" style="background-color: #FFE5B4;">
						<div class="title-wrapper">
							<p><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Average Occupancy Rate','mod'=>'dashperformance'),$_smarty_tpl ) );?>
</p>
						</div>
						<div class="value-wrapper">
							<span id="dp_average_occupancy_rate" style="color: #E09400;">--</span>
						</div>
					</div>
				</div>
                <div class="col-xs-6 col-lg-3">
					<div class="stat-box label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Direct Revenue Ratio (DRR) measures the percentage of online revenue that comes directly from your website vs. third party channels.','mod'=>'dashperformance'),$_smarty_tpl ) );?>
" data-placement="top" style="background-color: #B6FFB6;">
						<div class="title-wrapper">
							<p><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Direct Revenue Ratio','mod'=>'dashperformance'),$_smarty_tpl ) );?>
</p>
						</div>
						<div class="value-wrapper">
							<span id="dp_direct_revenue_ratio" style="color: #00B200;">--</span>
						</div>
					</div>
				</div>
                <div class="col-xs-6 col-lg-3">
					<div class="stat-box label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Cancellation Rate (CR) is the percentage of all cancelled orders out of all orders over a given time period.','mod'=>'dashperformance'),$_smarty_tpl ) );?>
" data-placement="top" style="background-color: #FFBBB8;">
						<div class="title-wrapper">
							<p><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Cancellation Rate','mod'=>'dashperformance'),$_smarty_tpl ) );?>
</p>
						</div>
						<div class="value-wrapper">
							<span id="dp_cancellation_rate" style="color: #FF4036;">--</span>
						</div>
					</div>
				</div>
                <div class="col-xs-6 col-lg-3">
					<div class="stat-box label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Revenue Per Available Room (RevPAR) is calculated by dividing total rooms revenue by the total number of rooms in the period being measured.','mod'=>'dashperformance'),$_smarty_tpl ) );?>
" data-placement="top" style="background-color: #B6FFB6;">
						<div class="title-wrapper">
							<p><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Revenue Per Available Room','mod'=>'dashperformance'),$_smarty_tpl ) );?>
</p>
						</div>
						<div class="value-wrapper">
							<span id="dp_revenue_per_available_room" style="color: #00B200;">--</span>
						</div>
					</div>
				</div>
				<div class="col-xs-6 col-lg-3">
					<div class="stat-box label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Total Revenue Per Available Room (TrevPAR) measures the total revenue being generated per available room including additional facilities and service products.','mod'=>'dashperformance'),$_smarty_tpl ) );?>
" data-placement="top" style="background-color: #EBCDFF;">
						<div class="title-wrapper">
							<p><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Total Revenue Per Available Room','mod'=>'dashperformance'),$_smarty_tpl ) );?>
</p>
						</div>
						<div class="value-wrapper">
							<span id="dp_total_revenue_per_available_room" style="color: #FF4036;">--</span>
						</div>
					</div>
				</div>
				<div class="col-xs-6 col-lg-3">
					<div class="stat-box label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Gross Operating Profit Per Available Room (GOPPAR) measures how much gross operating profit comes from each room including additional facilities and service products.','mod'=>'dashperformance'),$_smarty_tpl ) );?>
" data-placement="top" style="background-color: #B7F0FF;">
						<div class="title-wrapper">
							<p><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Gross Operating Profit Per Available Room','mod'=>'dashperformance'),$_smarty_tpl ) );?>
</p>
						</div>
						<div class="value-wrapper">
							<span id="dp_gross_operating_profit_par" style="color: #0093BA;">--</span>
						</div>
					</div>
				</div>
				<div class="col-xs-6 col-lg-3">
					<div class="stat-box label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Average Length of Stay (ALOS) is the average amount of days guests stay at the hotel over a given time period.','mod'=>'dashperformance'),$_smarty_tpl ) );?>
" data-placement="top" style="background-color: #FFE5B4;">
						<div class="title-wrapper">
							<p><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Average Length of Stay','mod'=>'dashperformance'),$_smarty_tpl ) );?>
</p>
						</div>
						<div class="value-wrapper">
							<span id="dp_average_length_of_stay" style="color: #E09400;">--</span>
						</div>
					</div>
				</div>
			</div>
		</section>
	</section>
</div>
<div class="clearfix"></div>
<?php }
}
