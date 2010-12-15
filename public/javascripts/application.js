jQuery(document).ready(function(){

	jQuery("a.fancy-edit").fancybox({ 'overlayShow' : false, 'hideOnOverlayClick' : false, 'hideOnContentClick' : false, 'frameWidth' : 500, 'frameHeight' : 600 }); 
	
	// Tabs for facts on show project page
	jQuery('#show_new').click(function(){
    jQuery('.fact-panel').hide();
    jQuery('#new-fact').show();
    return false;
  });
  jQuery('#show_facts').click(function(){
    jQuery('.fact-panel').hide();
    jQuery('#project-list').show();
    return false;
  });
  jQuery('#show_comments').click(function(){
    jQuery('.fact-panel').hide();
    jQuery('#comments').show();
    return false;
  });

	// Force mce save and show the 'waiting' text on forms
	jQuery('.mce_submit').live("click", function(){
	  tinyMCE.triggerSave(true, true);
	  jQuery(this).hide();
	  jQuery(this).siblings('.waiting').show();
	});

	jQuery('.submit_wait').live("click", function(){
	  jQuery(this).hide();
	  jQuery(this).siblings('.waiting').show();
	});
	
	// Hide and show facts under categories
	jQuery(".category-link").live("click", function(){
		jQuery(this).siblings('ul').toggle();
	});
	
	jQuery(document).oneTime(2000, "notify-box", function() {
		jQuery('.notify-box').fadeOut();
	});
	
	// // Tag suggest
	//   jQuery('.tag-link').live("click", function(){
	//     jQuery('.tag_list').val(jQuery(this).attr('title'));
	// 	jQuery('.current_tag').removeClass('current_tag');
	// 	jQuery(this).children('img').addClass('current_tag');
	// 	// var tag = jQuery(this).html();
	//     //     var tags = jQuery('.tag_list').val()
	//     //     if(tags.length > 0){
	//     //       tags = tags.split(',');
	//     //     } else {
	//     //       tags = [];
	//     //     }
	//     //     var add = true;
	//     //     var tags_cleaned = [];
	//     //     for(i=0;i<tags.length;i++){
	//     //       cleaned_tag = tags[i].split(" ").join("");
	//     //       if(cleaned_tag.length > 0){
	//     //         tags_cleaned.push(cleaned_tag);
	//     //       }        
	//     //       if(cleaned_tag == tag){
	//     //         add = false;
	//     //       }
	//     //     }
	//     //     if(add){
	//     //       tags_cleaned.push(tag);
	//     //     }
	//     //     jQuery('.tag_list').val(tags_cleaned.join(', '));
	//     return false;
	//   });

});

function apply_icon_dnd() {
  var $drop = jQuery('#select-icons-drop');
  var $drop_delete = jQuery('#select-icons-delete');
	jQuery("#select-icons-drop").sortable({
		connectWith: '.connectedSortable',
    update: function(event, ui) {
      var order = $(this).sortable('toArray').toString();
      // TODO Submit new icon ordering to the server. This will probably go to the app_map object. Which means the app_map will need a way to hold it.
    },
    receive: function(event, ui) {
      addIcon(ui.item);
    },
    remove: function(event, ui) { 
      removeIcon(ui.item);
    }
	}).disableSelection();
	jQuery("#select-icons-delete").sortable({
		connectWith: '.connectedSortable'
	}).disableSelection();
  function addIcon($item) {
    $item.fadeOut(100, function() {
      $item.appendTo($drop).show();
      var tags = jQuery('.select-tag-list').val();
      var new_list = add_to_list(tags, $item.children('.tag-name').html());
      jQuery('.select-tag-list').val(new_list);
      jQuery('#select-tag-form').submit();
			return false;
    });
  }
  function removeIcon($item) {
    $item.fadeOut(100, function() {
      $item.appendTo($drop_delete).show();
      var tags = jQuery('.select-tag-list').val();
      var new_list = remove_from_list(tags, $item.children('.tag-name').html());
      jQuery('.select-tag-list').val(new_list);
      jQuery('#select-tag-form').submit();
			return false;
    });
  }
}
