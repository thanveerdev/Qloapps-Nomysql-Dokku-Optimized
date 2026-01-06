<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:00
  from '/home/qloapps/www/QloApps/modules/dashguestcycle/views/templates/hook/dashboard-top.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce01e5242_20838842',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '51be5c39f54034b0e18e53ff373538d3b010edf3' => 
    array (
      0 => '/home/qloapps/www/QloApps/modules/dashguestcycle/views/templates/hook/dashboard-top.tpl',
      1 => 1753273976,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce01e5242_20838842 (Smarty_Internal_Template $_smarty_tpl) {
?>
<div class="row">
	<div class="col-xs-12">
		<section id="dashguestcycle" class="dashboard-top widget allow_push">
			<div class="badges-wrapper">
				<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['hook'][0], array( array('h'=>"displayDashboardBadgeListBefore"),$_smarty_tpl ) );?>

				<div class="badge-wrapper">
					<div class="badge-item label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'The number of arrivals scheduled for today.','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
">
						<div class="badge-strip" style="background-color: #266FFE;"></div>
						<div class="badge-content-wrapper">
							<div class="title-wrapper">
								<p class="text-center"><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Arrivals",'mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
</p>
							</div>
							<div class="value-wrapper">
								<p class="text-center">
									<span id="dgc_arrived"></span>/<span id="dgc_total_arrivals"></span>
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="badge-wrapper">
					<div class="badge-item label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'The number of departures scheduled for today.','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
">
						<div class="badge-strip" style="background-color: #72C3F0;"></div>
						<div class="badge-content-wrapper">
							<div class="title-wrapper">
								<p class="text-center"><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Departures",'mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
</p>
							</div>
							<div class="value-wrapper">
								<p class="text-center">
									<span id="dgc_departed"></span>/<span id="dgc_total_departures"></span>
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="badge-wrapper">
					<div class="badge-item label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'The number of new bookings created today so far.','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
">
						<div class="badge-strip" style="background-color: #56CE56;"></div>
						<div class="badge-content-wrapper">
							<div class="title-wrapper">
								<p class="text-center"><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"New Bookings",'mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
</p>
							</div>
							<div class="value-wrapper">
								<p class="text-center">
									<span id="dgc_new_bookings"></span>
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="badge-wrapper">
					<div class="badge-item label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'The count of rooms that are currently occupied by guests.','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
">
						<div class="badge-strip" style="background-color: #FFC148;"></div>
						<div class="badge-content-wrapper">
							<div class="title-wrapper">
								<p class="text-center"><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Occupied Rooms','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
</p>
							</div>
							<div class="value-wrapper">
								<p class="text-center">
									<span id="dgc_occupied"></span>
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="badge-wrapper">
					<div class="badge-item label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'The number of new messages received from guests today.','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
">
						<div class="badge-strip" style="background-color: #A569DF;"></div>
						<div class="badge-content-wrapper">
							<div class="title-wrapper">
								<p class="text-center">
									<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Guest Messages",'mod'=>'dashguestcycle'),$_smarty_tpl ) );?>

								</p>
							</div>
							<div class="value-wrapper">
								<p class="text-center">
									<span id="dgc_new_messages"></span>
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="badge-wrapper">
					<div class="badge-item label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'The number of bookings cancelled today so far.','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
">
						<div class="badge-strip" style="background-color: #FF4036;"></div>
						<div class="badge-content-wrapper">
							<div class="title-wrapper">
								<p class="text-center">
									<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Cancelled Bookings",'mod'=>'dashguestcycle'),$_smarty_tpl ) );?>

								</p>
							</div>
							<div class="value-wrapper">
								<p class="text-center">
									<span id="dgc_cancelled_bookings"></span>
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="badge-wrapper">
					<div class="badge-item label-tooltip" data-toggle="tooltip" data-original-title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'The number of adults and children scheduled to stay today.','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
">
						<div class="badge-strip" style="background-color: #FF809E;"></div>
						<div class="badge-content-wrapper">
							<div class="title-wrapper">
								<p class="text-center">
									<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>"Guests (Adults/Children)",'mod'=>'dashguestcycle'),$_smarty_tpl ) );?>

								</p>
							</div>
							<div class="value-wrapper">
								<p class="text-center">
									<span id="dgc_guests_adults"></span>/<span id="dgc_guests_children"></span>
								</p>
							</div>
						</div>
					</div>
				</div>
				<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['hook'][0], array( array('h'=>"displayDashboardBadgeListAfter"),$_smarty_tpl ) );?>

			</div>
		</section>
	</div>
</div>
<?php }
}
