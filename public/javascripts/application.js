// compress with http://closure-compiler.appspot.com/home
//jQuery.noConflict();
jQuery(document).ajaxSend(function(event, request, settings) {
  add_headers(request);
  if (settings.type.toUpperCase() == 'GET' || typeof(AUTH_TOKEN) == "undefined") return; // for details see: http://www.justinball.com/2009/07/08/jquery-ajax-get-in-firefox-post-in-internet-explorer/
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
 	if (typeof(AUTH_TOKEN) != "undefined")
  	settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

function apply_ajax_forms() {
  jQuery('form.ajax').ajaxForm({
    dataType: 'script',
    beforeSend: add_headers
  });
	jQuery('form.ajax').append('<input type="hidden" name="format" value="js" />');
}

function add_headers(xhr){
	xhr.setRequestHeader("Accept", "text/javascript");
	xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
}

function applyEditor(){
	jQuery("a.inline-edit").fancybox({'autoDimensions':true});
	// jQuery('a.inline-edit').click(function(){
	// 	jQuery(this).replaceWith(jQuery('#waiting').show());
	// 	return false;
	// });
}

function apply_fancy_gpsrs(){
	jQuery("a.fancy-gpsrs").fancybox({ 'overlayShow': false, 'hideOnOverlayClick': false, 'hideOnContentClick': false }); 
}

jQuery(document).ready(function(){

	jQuery("a.fancy-edit").fancybox({ 'overlayShow': false, 'hideOnOverlayClick': false, 'hideOnContentClick': false, 'width': 500, 'height': 600, 'autoDimensions': false, 'autoScale': false }); 
	
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

  jQuery('.tag-link').live("click", function(){
    jQuery('.tag_list').val(jQuery(this).attr('title'));
		jQuery('.current_tag').removeClass('current_tag');
		jQuery(this).children('img').addClass('current_tag');
		return false;
	// // Tag suggest
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
	});

	jQuery('a.ajax-delete').live('click', function() {
    var title = jQuery(this).attr('title');
    var do_delete = true;
    if(title.length > 0){
      do_delete = confirm(title);
    }
    if (do_delete){
      jQuery.post(this.href, { _method: 'delete', format: 'js' }, null, "script");
    }
    return false;
  });

  jQuery('a.ajax-update').live('click', function() {
    jQuery.post(this.href, { _method: 'put', format: 'js' }, null, "script");
    return false;
  });

  jQuery(".submit-form").click(function() {
    jQuery(this).parent('form').submit();
  });

  apply_ajax_forms();

  jQuery('a.dialog-pop').live('click', function() {
    var d = jQuery('<div class="dialog"></div>').appendTo("body");
    d.dialog({ modal: true, autoOpen: false, width: 'auto', title: jQuery(this).attr('title') });
    d.load(jQuery(this).attr('href'), '', function(){
      d.dialog("open");
      apply_ajax_forms();
    });
    return false;
  });

  jQuery(".submit-delete").live('click', function() {
    jQuery(this).parents('.delete-container').fadeOut();
    var form = jQuery(this).parents('form');
    jQuery.post(form.attr('action') + '.json', form.serialize(),
      function(data){
        var json = eval('(' + data + ')');
        if(!json.success){
          jQuery.jGrowl.info(json.message);
        }
      });
    return false;
  });
  
  jQuery(".submit-delete-js").live('click', function() {
    jQuery(this).parents('.delete-container').fadeOut();
    var form = jQuery(this).parents('form');
    jQuery.post(form.attr('action') + '.js', form.serialize(),
      function(data){
      });
    return false;
  });

  jQuery(document).ready(function() {
    jQuery('.waiting').hide();
    jQuery(".wait-button").live('click', function() {
      jQuery(this).siblings('.waiting').show();
      jQuery(this).hide();
    });
  });

  jQuery('a.add_child').live("click", function() {
    var association = jQuery(this).attr('data-association');
    var template = jQuery(this).prev().html();
    var regexp = new RegExp('new_' + association, 'g');
    var new_id = new Date().getTime();
    jQuery(this).parent().before(template.replace(regexp, new_id));
    return false;
  });

  jQuery('a.remove_child').live('click', function() {
    var hidden_field = jQuery(this).prev('input[type=hidden]')[0];
    if(hidden_field) {
      hidden_field.value = '1';
    }
    jQuery(this).parents('.fields:first').hide();
    return false;
  });

});

function apply_fact_sort(url){
	jQuery("#sort-facts").sortable({
		axis: 'y',
		opacity: 0.4,
		scroll: true,
    update: function(event, ui) {
			jQuery.ajax({
          type: 'post',
          data: jQuery('#sort-facts').sortable('serialize'),
          dataType: 'script',
          complete: function(request) {
          	jQuery('#sort-facts').effect('highlight');
          },
          url: url
      })
    }
	}).disableSelection();	
}

function apply_content_methods(url, update_server){
	var update = null;
	
	if(update_server){
		update = function(event, ui) {
			jQuery.ajax({
          type: 'post',
          data: jQuery('#content-list').sortable('serialize'),
          dataType: 'script',
          complete: function(request) {
          	jQuery('#content-list').effect('highlight');
          },
          url: url
      });
		}
	}
	
	jQuery("#content-list").sortable({
		axis: 'y',
		opacity: 0.4,
		scroll: true,
    update: update 
  }).disableSelection();


	jQuery('select.content-category-select').live('change', function(){
	  var select = jQuery(this);
		var content_answers_container = select.parents('li').siblings('li.content-answers-container');
	  if(select.val() == 'question'){
	    content_answers_container.show();
	  } else {
			content_answers_container.hide();
		}
	});
	
	jQuery('.content-answers-toggle').live('click', function(){
		var link = jQuery(this);
		var answers = link.siblings('.content-answers');		
		if(answers.is(":visible")){
			link.html('Show Answers');
			answers.hide();
		} else {
			answers.show();
			link.html('Hide Answers');
		}
		return false;
	});
	
}

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

// String list methods. These are handy for dealing with comma delimited lists
// in text boxes such as a list of emails or tags.
// Given a comma delimited string add a new item if it isn't in the string
function add_to_list(items_string, new_item){
  var items = split_list(items_string);
  var add = true;
  for(i=0;i<items.length;i++){
    if(items[i] == new_item){ add = false; }
  }
  if(add){ 
    items.push(new_item);
  }
  return items.join(', ');
}

// Given a comma delimited list remove an item from the string
function remove_from_list(items_string, remove_item){
  var items = split_list(items_string);
  var cleaned = [];
  for(i=0;i<items.length;i++){
    if(items[i] != remove_item){
      cleaned.push(items[i]);
    }
  }
  return cleaned.join(', ');
}

// Split a string on commas
function split_list(items_string){
  if(undefined != items_string && items_string.length > 0){
    var items = items_string.split(',');
  } else {
    var items = [];
  }
  var cleaned = [];
  for(i=0;i<items.length;i++){
    var cleaned_item = jQuery.trim(items[i]);
    if(cleaned_item.length > 0){ 
      cleaned.push(cleaned_item); 
    }
  }
  return cleaned;
}

function isEncodedHtml(str) { 
  if(str.search(/&amp;/g) != -1 || str.search(/&lt;/g) != -1 || str.search(/&gt;/g) != -1) 
    return true; 
  else 
    return false; 
}; 
 
function decodeHtml(str){ 
    if(isEncodedHtml(str)) 
      return str.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>'); 
    return str; 
}
