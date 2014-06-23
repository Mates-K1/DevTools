<?php
/**
 * Custom theme page for displaying the yearly and monthly archive of gallery items and Zenpage news articles
 */
if (!defined('WEBPATH'))
	die();
?>
<!DOCTYPE html>
<html>
	<head>
		<?php zp_apply_filter('theme_head'); ?>
		<link rel="stylesheet" href="<?php echo $_zp_themeroot; ?>/style.css" type="text/css" />
		<?php if (class_exists('RSS')) printRSSHeaderLink('Gallery', gettext_th('Gallery RSS')); ?>
	</head>
	<body>
		<?php zp_apply_filter('theme_body_open'); ?>
		<?php printGalleryTitle(); ?>
		<a href="<?php echo getGalleryIndexURL(); ?>" title="<?php gettext_th('Index'); ?>"><?php echo gettext_th("Index"); ?></a> » <strong><?php echo gettext_th("Archive View"); ?>
			<?php
			if (getOption('Allow_search')) {
				printSearchForm("", "search", "", gettext_th("Search gallery"));
			}
			?>
			<a href="<?php echo getGalleryIndexURL(); ?>">Index</a> » <?php echo gettext_th("Object not found"); ?>
			<?php printAllDates(); // prints the gallery archive list by year and month ?>
			<?php
			// Support for the Zenpage news archive
			if (function_exists("printNewsArchive")) {
				printNewsArchive("archive");
			}
			?>
			<?php printAllTagsAs('cloud', 'tags'); // a tag cloud of all tags ?>
			<?php printZenphotoLink(); ?>
			<?php zp_apply_filter('theme_body_close'); ?>
	</body>
</html>