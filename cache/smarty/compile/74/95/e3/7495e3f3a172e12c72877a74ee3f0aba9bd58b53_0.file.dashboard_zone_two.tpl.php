<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:00
  from '/home/qloapps/www/QloApps/modules/dashavailability/views/templates/hook/dashboard_zone_two.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce0315377_37545292',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '7495e3f3a172e12c72877a74ee3f0aba9bd58b53' => 
    array (
      0 => '/home/qloapps/www/QloApps/modules/dashavailability/views/templates/hook/dashboard_zone_two.tpl',
      1 => 1753273976,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce0315377_37545292 (Smarty_Internal_Template $_smarty_tpl) {
?>
<div class="col-md-12 col-lg-12">
	<section id="dashavailability" class="panel widget allow_push">
		<header class="panel-heading">
			<i class="icon-bar-chart"></i>
			<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Availability",'mod'=>'dashavailability'),$_smarty_tpl ) );?>

			<span class="panel-heading-action">
			<a class="list-toolbar-btn" href="javascript:void(0);" title="Refresh" onclick="refreshAvailabilityBarData();" title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Refresh",'mod'=>'dashavailability'),$_smarty_tpl ) );?>
">
					<i class="process-icon-refresh"></i>
				</a>
			</span>
		</header>
		<div class="row avil-chart-head">
				<div class="col-xs-5 col-lg-6">
					<div class="pull-left">
						<button class="avail-bar-date datepicker" type="button" id="avail_datepicker"
						onclick="availDatePicker()">
							<i class="icon-calendar-empty"></i>
							<span class="hidden-xs bar-date">
								<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"From",'mod'=>'dashavailability'),$_smarty_tpl ) );?>

								<strong><?php echo htmlentities(mb_convert_encoding((string)$_smarty_tpl->tpl_vars['dateFromBar']->value, 'UTF-8', 'UTF-8'), ENT_QUOTES, 'UTF-8', true);?>
</strong>
							</span>
							<i class="icon-caret-down"></i>
						</button>
						<input type="text" id="bardate" name="datepickerFrom" class="datepicker">
					</div>
				</div>
				<div class="col-xs-2 col-md-2  col-lg-2 pull-left">
					<button id='avail_bar_day_5' class="avail-bar-btn bar-btn-active" data-days="5">
						<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"5 Days",'mod'=>'dashavailability'),$_smarty_tpl ) );?>

					</button>
				</div>
				<div class="col-xs-2 col-md-2  col-lg-2 pull-left">
					<button id='avail_bar_day_15' class="avail-bar-btn" data-days="15)">
						<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"15 Days",'mod'=>'dashavailability'),$_smarty_tpl ) );?>

					</button>
				</div>
				<div class="col-xs-2 col-md-2  col-lg-2 pull-left">
					<button id='avail_bar_day_30' class="avail-bar-btn" data-days="30)">
						<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"30 Days",'mod'=>'dashavailability'),$_smarty_tpl ) );?>

					</button>
				</div>
		</div>
		<div class="avil-chart-svg" id="availability_line_chart1">
			<svg></svg>
		</div>
	</section>
</div><?php }
}
