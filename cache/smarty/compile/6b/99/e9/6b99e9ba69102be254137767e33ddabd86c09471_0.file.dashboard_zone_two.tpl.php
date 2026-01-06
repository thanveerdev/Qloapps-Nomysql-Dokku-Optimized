<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:00
  from '/home/qloapps/www/QloApps/modules/dashgoals/views/templates/hook/dashboard_zone_two.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce034c302_45267751',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '6b99e9ba69102be254137767e33ddabd86c09471' => 
    array (
      0 => '/home/qloapps/www/QloApps/modules/dashgoals/views/templates/hook/dashboard_zone_two.tpl',
      1 => 1753273976,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:./config.tpl' => 1,
  ),
),false)) {
function content_69022ce034c302_45267751 (Smarty_Internal_Template $_smarty_tpl) {
?>
<div class="clearfix"></div>
<div class="col-sm-12">
	<?php echo '<script'; ?>
>
		var currency_format = <?php echo intval($_smarty_tpl->tpl_vars['currency']->value->format);?>
;
		var currency_sign = "<?php echo addslashes($_smarty_tpl->tpl_vars['currency']->value->sign);?>
";
		var currency_blank = <?php echo intval($_smarty_tpl->tpl_vars['currency']->value->blank);?>
;
		var priceDisplayPrecision = 0;
		var dashgoals_year = <?php echo intval($_smarty_tpl->tpl_vars['goals_year']->value);?>
;
		var dashgoals_ajax_link = "<?php echo addslashes($_smarty_tpl->tpl_vars['dashgoals_ajax_link']->value);?>
";
	<?php echo '</script'; ?>
>

	<section id="dashgoals" class="panel widget">
		<header class="panel-heading">
			<i class="icon-bar-chart"></i>
			<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Target','mod'=>'dashgoals'),$_smarty_tpl ) );?>

			<span id="dashgoals_title" class="badge"><?php echo $_smarty_tpl->tpl_vars['goals_year']->value;?>
</span>
			<span class="btn-group">
				<a href="javascript:void(0);" onclick="dashgoals_changeYear('backward');" class="btn btn-default btn-xs"><i class="icon-backward"></i></a>
				<a href="javascript:void(0);" onclick="dashgoals_changeYear('forward');" class="btn btn-default btn-xs"><i class="icon-forward"></i></a>
			</span>

			<span class="panel-heading-action">
				<a class="list-toolbar-btn" href="javascript:void(0);" onclick="toggleDashConfig('dashgoals');" title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Configure",'mod'=>'dashtrends'),$_smarty_tpl ) );?>
">
					<i class="process-icon-configure"></i>
				</a>
				<a class="list-toolbar-btn" href="javascript:void(0);" onclick="refreshDashboard('dashgoals');" title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Refresh",'mod'=>'dashtrends'),$_smarty_tpl ) );?>
">
					<i class="process-icon-refresh"></i>
				</a>
			</span>
		</header>
		<?php $_smarty_tpl->_subTemplateRender('file:./config.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
		<section class="loading text-center">
			<div class="alert alert-info text-left">
				<p><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Set your targets by clicking the configuration button at right position of the header in this section.','mod'=>'dashgoals'),$_smarty_tpl ) );?>
</p>
				<p><b><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Note','mod'=>'dashgoals'),$_smarty_tpl ) );?>
:</b> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Targets will be set and data will be displayed for all the hotels.','mod'=>'dashgoals'),$_smarty_tpl ) );?>
</p>
			</div>
			<div class="dashgoals row">
                <div class="col-xs-6 col-sm-3">
					<label class="btn btn-default label-tooltip" style="background-color:<?php echo $_smarty_tpl->tpl_vars['colors']->value[3];?>
;"
						data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Sales is the measure of total sales on your website over a given time period.",'mod'=>"dashgoals"),$_smarty_tpl ) );?>
">
						<input type="radio" name="options" onchange="selectDashgoalsChart('sales');"/>
						<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Sales",'mod'=>'dashgoals'),$_smarty_tpl ) );?>

					</label>
				</div>
				<div class="col-xs-6 col-sm-3">
					<label class="btn btn-default label-tooltip" style="background-color:<?php echo $_smarty_tpl->tpl_vars['colors']->value[0];?>
;"
						data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Traffic is the measure of number of visitors on your website over a given time period.",'mod'=>'dashgoals'),$_smarty_tpl ) );?>
">
						<input type="radio" name="options" onchange="selectDashgoalsChart('traffic');"/>
						<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Traffic",'mod'=>'dashgoals'),$_smarty_tpl ) );?>

					</label>
				</div>
				<div class="col-xs-6 col-sm-3">
					<label class="btn btn-default label-tooltip" style="background-color:<?php echo $_smarty_tpl->tpl_vars['colors']->value[1];?>
;"
						data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Conversion is the measure of visitors who make a booking on your website over a given time period.",'mod'=>'dashgoals'),$_smarty_tpl ) );?>
">
						<input type="radio" name="options" onchange="selectDashgoalsChart('conversion');"/>
						<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Conversion",'mod'=>'dashgoals'),$_smarty_tpl ) );?>

					</label>
				</div>
				<div class="col-xs-6 col-sm-3">
					<label class="btn btn-default label-tooltip" style="background-color:<?php echo $_smarty_tpl->tpl_vars['colors']->value[2];?>
;"
						data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Average Order Value is the average amount spent on each booking over a given time period.",'mod'=>'dashgoals'),$_smarty_tpl ) );?>
">
						<input type="radio" name="options" onchange="selectDashgoalsChart('avg_cart_value');"/>
						<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Avg. Order Value",'mod'=>'dashgoals'),$_smarty_tpl ) );?>

					</label>
				</div>
			</div>
			<div id="dash_goals_chart1" class="chart with-transitions">
				<svg></svg>
			</div>
		</section>
	</section>
</div>
<div class="clearfix"></div><?php }
}
