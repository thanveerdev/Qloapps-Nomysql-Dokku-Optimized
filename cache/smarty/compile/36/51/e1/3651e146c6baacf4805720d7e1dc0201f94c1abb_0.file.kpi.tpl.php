<?php
/* Smarty version 4.5.5, created on 2025-10-29 19:04:03
  from '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/helpers/kpi/kpi.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.5',
  'unifunc' => 'content_69022ce3d82cb3_65223814',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '3651e146c6baacf4805720d7e1dc0201f94c1abb' => 
    array (
      0 => '/home/qloapps/www/QloApps/adminf30cd1f0/themes/default/template/helpers/kpi/kpi.tpl',
      1 => 1753273972,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69022ce3d82cb3_65223814 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_checkPlugins(array(0=>array('file'=>'/home/qloapps/www/QloApps/tools/smarty/plugins/modifier.replace.php','function'=>'smarty_modifier_replace',),));
?>

<<?php if ((isset($_smarty_tpl->tpl_vars['href']->value)) && $_smarty_tpl->tpl_vars['href']->value) {?>a style="display:block" href="<?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['href']->value, ENT_QUOTES, 'UTF-8', true);?>
"<?php } else { ?>div<?php }?> id="<?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['id']->value, ENT_QUOTES, 'UTF-8', true);?>
" data-toggle="tooltip" class="box-stats label-tooltip <?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['color']->value, ENT_QUOTES, 'UTF-8', true);?>
" data-original-title="<?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['tooltip']->value, ENT_QUOTES, 'UTF-8', true);?>
" <?php if ($_smarty_tpl->tpl_vars['target']->value) {?>target="_blank"<?php }?>>
	<div class="kpi-content">
		<?php if ((isset($_smarty_tpl->tpl_vars['icon']->value)) && $_smarty_tpl->tpl_vars['icon']->value) {?><i class="<?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['icon']->value, ENT_QUOTES, 'UTF-8', true);?>
 kpi-icon"></i><?php }?>
		<div class="kpi-data">
			<div class="title-subtitle">
				<div class="title-container">
					<span class="title">
						<?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['title']->value, ENT_QUOTES, 'UTF-8', true);?>

					</span>
				</div>
				<?php if ($_smarty_tpl->tpl_vars['subtitle']->value) {?>
					<div class="subtitle-container">
						<span class="subtitle">
							<?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['subtitle']->value, ENT_QUOTES, 'UTF-8', true);?>

						</span>
					</div>
				<?php }?>
			</div>
			<?php if ((isset($_smarty_tpl->tpl_vars['chart']->value)) && $_smarty_tpl->tpl_vars['chart']->value) {?>
				<div class="boxchart-overlay">
					<div class="boxchart">
					</div>
				</div>
			<?php }?>
			<div class="value-container">
				<?php if ((isset($_smarty_tpl->tpl_vars['source']->value)) && $_smarty_tpl->tpl_vars['source']->value) {?>
					<span class="value skeleton-loading-wave loading-container-bar loading"></span>
				<?php } elseif ((isset($_smarty_tpl->tpl_vars['value']->value)) && $_smarty_tpl->tpl_vars['value']->value !== '') {?>
					<span class="value"><?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['value']->value, ENT_QUOTES, 'UTF-8', true);?>
</span>
				<?php }?>
			</div>
			<?php if ((isset($_smarty_tpl->tpl_vars['href']->value)) && $_smarty_tpl->tpl_vars['href']->value) {?>
				<span class="arrow pull-right"><i class="icon-angle-right"></i></span>
			<?php }?>
		</div>

		</div>
</<?php if ((isset($_smarty_tpl->tpl_vars['href']->value)) && $_smarty_tpl->tpl_vars['href']->value) {?>a<?php } else { ?>div<?php }?>>

<?php if ((isset($_smarty_tpl->tpl_vars['source']->value)) && $_smarty_tpl->tpl_vars['source']->value) {?>
	<?php echo '<script'; ?>
>
		function refresh_<?php echo addslashes(smarty_modifier_replace($_smarty_tpl->tpl_vars['id']->value,'-','_'));?>
()
		{
			$.ajax({
				url: '<?php echo addslashes($_smarty_tpl->tpl_vars['source']->value);?>
' + '&rand=' + new Date().getTime(),
				dataType: 'json',
				type: 'GET',
				cache: false,
				headers: { 'cache-control': 'no-cache' },
				beforeSend: function() {
					$('#<?php echo addslashes($_smarty_tpl->tpl_vars['id']->value);?>
').find('.value').html('');
					$('#<?php echo addslashes($_smarty_tpl->tpl_vars['id']->value);?>
').find('.value').addClass('skeleton-loading-wave loading-container-bar loading');
				},
				success: function(jsonData){
					if (!jsonData.has_errors)
					{
						if (jsonData.value != undefined)
							$('#<?php echo addslashes($_smarty_tpl->tpl_vars['id']->value);?>
 .value').html(jsonData.value);
						if (jsonData.data != undefined)
						{
							$("#<?php echo addslashes($_smarty_tpl->tpl_vars['id']->value);?>
 .boxchart svg").remove();
							set_d3_<?php echo addslashes(smarty_modifier_replace($_smarty_tpl->tpl_vars['id']->value,'-','_'));?>
(jsonData.data);
						}
					}
				},
				complete: function () {
					$('#<?php echo addslashes($_smarty_tpl->tpl_vars['id']->value);?>
').find('.value').removeClass('skeleton-loading-wave loading-container-bar loading');
				},
			});
		}
	<?php echo '</script'; ?>
>
<?php }?>

<?php if ($_smarty_tpl->tpl_vars['chart']->value) {
echo '<script'; ?>
>
	function set_d3_<?php echo addslashes(smarty_modifier_replace($_smarty_tpl->tpl_vars['id']->value,'-','_'));?>
(jsonObject)
	{
		var data = new Array;
		$.each(jsonObject, function (index, value) {
			data.push(value);
		});
		var data_max = d3.max(data);

		var chart = d3.select("#<?php echo addslashes($_smarty_tpl->tpl_vars['id']->value);?>
 .boxchart").append("svg")
			.attr("class", "data_chart")
			.attr("width", data.length * 6)
			.attr("height", 45);

		var y = d3.scale.linear()
			.domain([0, data_max])
			.range([0, data_max * 45]);

		chart.selectAll("rect")
			.data(data)
			.enter().append("rect")
			.attr("y", function(d) { return 45 - d * 45 / data_max; })
			.attr("x", function(d, i) { return i * 6; })
			.attr("width", 4)
			.attr("height", y);
	}

	<?php if ($_smarty_tpl->tpl_vars['data']->value) {?>
		set_d3_<?php echo addslashes(smarty_modifier_replace($_smarty_tpl->tpl_vars['id']->value,'-','_'));?>
($.parseJSON("<?php echo addslashes($_smarty_tpl->tpl_vars['data']->value);?>
"));
	<?php }
echo '</script'; ?>
>
<?php }
}
}
