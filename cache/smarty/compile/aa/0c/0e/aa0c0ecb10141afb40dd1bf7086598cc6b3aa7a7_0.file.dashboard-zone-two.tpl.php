<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:00
  from '/home/qloapps/www/QloApps/modules/dashguestcycle/views/templates/hook/dashboard-zone-two.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce03057a2_72226577',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'aa0c0ecb10141afb40dd1bf7086598cc6b3aa7a7' => 
    array (
      0 => '/home/qloapps/www/QloApps/modules/dashguestcycle/views/templates/hook/dashboard-zone-two.tpl',
      1 => 1753273976,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce03057a2_72226577 (Smarty_Internal_Template $_smarty_tpl) {
?>
<div class="col-sm-12">
    <section id="dashguestcycle" class="panel widget allow_push">
        <header class="panel-heading">
            <i class="icon-bar-chart"></i> <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Operations Today','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>

            <span class="panel-heading-action">
                <a class="list-toolbar-btn" href="#" onclick="refreshDashboard('dashguestcycle'); return false;"
                    title="<?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Refresh','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
">
                    <i class="process-icon-refresh"></i>
                </a>
            </span>
            <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['hook'][0], array( array('h'=>'displayDashGuestCycleHeader'),$_smarty_tpl ) );?>

        </header>

        <section>
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#dgc_current_arrivals" data-toggle="tab">
                        <span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Arrivals','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
</span>
                        <span class="label label-info" id="dgc_count_upcoming_arrivals">0</span>
                    </a>
                </li>
                <li>
                    <a href="#dgc_current_departures" data-toggle="tab">
                        <span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Departures','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
</span>
                        <span class="label label-info" id="dgc_count_upcoming_departures">0</span>
                    </a>
                </li>
                <li>
                    <a href="#dgc_current_in_house" data-toggle="tab">
                        <span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'In-house','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
</span>
                        <span class="label label-info" id="dgc_count_current_in_house">0</span>
                    </a>
                </li>
                <li>
                    <a href="#dgc_current_new_bookings" data-toggle="tab">
                        <span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'New Bookings','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
</span>
                        <span class="label label-info" id="dgc_count_new_bookings">0</span>
                    </a>
                </li>
                <li>
                    <a href="#dgc_current_cancellations" data-toggle="tab">
                        <span><?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['l'][0], array( array('s'=>'Cancellations','mod'=>'dashguestcycle'),$_smarty_tpl ) );?>
</span>
                        <span class="label label-info" id="dgc_count_cancellations">0</span>
                    </a>
                </li>
                <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['hook'][0], array( array('h'=>'displayDashGuestCycleTab'),$_smarty_tpl ) );?>

            </ul>

            <div class="tab-content panel panel-sm">
                <div class="tab-pane active" id="dgc_current_arrivals">
                    <table class="table table-striped" id="dgc_table_current_arrivals">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="tab-pane" id="dgc_current_departures">
                    <table class="table table-striped" id="dgc_table_current_departures">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="tab-pane" id="dgc_current_in_house">
                    <table class="table table-striped" id="dgc_table_current_in_house">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="tab-pane" id="dgc_current_new_bookings">
                    <table class="table table-striped" id="dgc_table_new_bookings">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="tab-pane" id="dgc_current_cancellations">
                    <table class="table table-striped" id="dgc_table_cancellations">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
                <?php echo call_user_func_array( $_smarty_tpl->smarty->registered_plugins[Smarty::PLUGIN_FUNCTION]['hook'][0], array( array('h'=>'displayDashGuestCycleTabContent'),$_smarty_tpl ) );?>

            </div>
        </section>
    </section>
</div>
<div class="clearfix"></div>
<?php }
}
