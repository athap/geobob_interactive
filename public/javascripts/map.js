// Calling page must define projectLatLng to center the map in case there are no facts available.
var markers = new Array();
var map;
var bounds;
var infowindow;
var paletteControl;
var newMarkerControl;

function init_map(){
  infowindow = new google.maps.InfoWindow();
	
	var google_map_options = {
	  mapTypeControl: true,
	  navigationControl: true,
	  mapTypeId: google.maps.MapTypeId.ROADMAP,
	  mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DROPDOWN_MENU },
	  navigationControlOptions: { style: google.maps.NavigationControlStyle.ZOOM_PAN },
		center: projectLatLng
	};
	
  map = new google.maps.Map(document.getElementById("map_content"), google_map_options);
  bounds = new google.maps.LatLngBounds();
  
	if(setupMarkers()){
		map.fitBounds(bounds);
	} else {
		map.setZoom(11);
		map.panTo(projectLatLng);
	}

	var newMarkerControlDiv = document.createElement('div');
	newMarkerControl = new NewMarkerControl(map, newMarkerControlDiv);
	newMarkerControlDiv.index = 2;
	map.controls[google.maps.ControlPosition.RIGHT].push(newMarkerControlDiv);

  var paletteControlDiv = document.createElement('div');
  paletteControl = new PaletteControl(map, paletteControlDiv);
  paletteControlDiv.index = 1;
	setupTags(paletteControl);
  map.controls[google.maps.ControlPosition.TOP_RIGHT].push(paletteControlDiv);
  
  var projectControl = document.getElementById("project");
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(projectControl);
  
	applyEditor();
	
	jQuery('.tag-link').live('click', function(){
	  jQuery('.tag_list').val(jQuery(this).attr('title'));
		jQuery('.current_tag').removeClass('current_tag');
		jQuery(this).children('img').addClass('current_tag');
	  return false;
	});
	
	jQuery("#open_new_fact").fancybox({'autoDimensions':true});

};

function applyEditor(){
	jQuery("a.inline-edit").fancybox({'autoDimensions':true});
	// jQuery('a.inline-edit').click(function(){
	// 	jQuery(this).replaceWith(jQuery('#waiting').show());
	// 	return false;
	// });
}

function setupMarker(id, dom_id, title, latLng, icon){
  var marker = new google.maps.Marker({ position: latLng, title: title, map: map, draggable: true, icon: icon });
  jQuery.data(marker, 'fact_id', id);
  bounds.extend(latLng);
  google.maps.event.addListener(marker,'click',function(){
    infowindow.setContent(jQuery('#' + dom_id).html());
    infowindow.open(map, marker);
		applyEditor();
  });
  google.maps.event.addListener(marker,'dragstart',function(event){
		infowindow.close();
  });
  google.maps.event.addListener(marker,'dragend',function(event){
    // Update object location on server
    jQuery.post('/facts/' + jQuery.data(marker, 'fact_id'), { '_method': 'put', 'format': 'js', 'lat': this.position.lat(), 'lng': this.position.lng() });
  });
  return marker;
}

function setFormContent(data){
	var container = document.createElement('div');
	container.style.width = "500px";
	container.style.height = "490px";
	container.style.backgroundColor = 'white';
  container.innerHTML = data;
	infowindow.setContent(container);
}

function latLngString(latLng){
	return latLng.lat() + ',' + latLng.lng();
}

// New Marker control
function NewMarkerControl(map, controlDiv) {
	this.map = map;
	this.controlDiv = controlDiv;
  this.controlDiv.style.padding = '5px';

  // Set CSS for the control border
  var controlUI = document.createElement('DIV');
  controlUI.style.backgroundColor = 'white';
  controlUI.style.borderStyle = 'solid';
  controlUI.style.borderWidth = '1px';
  controlUI.style.cursor = 'pointer';
  controlUI.style.textAlign = 'center';
  controlUI.title = 'Click to add a new fact';
  this.controlDiv.appendChild(controlUI);

  // Set CSS for the control interior
  var controlText = document.createElement('DIV');
  controlText.style.fontFamily = 'Arial,sans-serif';
  controlText.style.fontSize = '12px';
  controlText.style.padding = '0 28px';
  controlText.innerHTML = 'New';
  controlUI.appendChild(controlText);

  google.maps.event.addDomListener(controlUI, 'click', function() {
    jQuery("#open_new_fact").trigger('click');
  });
}

// Palette control
function PaletteControl(map, controlDiv) {
	this.map = map;
	this.controlDiv = controlDiv;
  this.controlDiv.style.padding = '2px';
}

PaletteControl.prototype.addTool = function(img) {
	var me = this;
  var icon = document.createElement('img');
  icon.src = img;
  this.controlDiv.appendChild(icon);
  google.maps.event.addDomListener(icon, 'click', function(event) {
		me.killMarker();
		cleanUp(true);
		jQuery("#map_content").append('<img id="current_cursor_icon" src="' + img + '" />');
		me.map.setOptions({draggableCursor: 'crosshair', draggingCursor: 'crosshair'});
		jQuery("#map_content").mousemove(function(e){
			var cursor = jQuery('#current_cursor_icon');
			var height = cursor.height();
			var width = cursor.width() / 2;
			cursor.css({ position: "absolute", marginLeft: 0, marginTop: 0, top: (e.pageY - height), left: (e.pageX - width) });
		});
		var clickListener;
		var rightClickListener;
		clickListener = google.maps.event.addDomListener(me.map, 'click', function(event) {
			cleanUp(false);
			me.createMarker(event.latLng, img);
			resetCursor();
		});
		rightClickListener = google.maps.event.addDomListener(me.map, 'rightclick', function(event) {
			cleanUp(true);
		});
		jQuery(document).bind('keypress', function(event) {
			if (event.keyCode == '27') {
				cleanUp(true);
		  }
		});
		function cleanUp(remove_cursor){
			jQuery('#map_content').unbind('mousemove');
			jQuery(document).unbind('keypress');
			if(clickListener) { google.maps.event.removeListener(clickListener); }
			if(rightClickListener) { google.maps.event.removeListener(rightClickListener); }
			if(remove_cursor) { resetCursor(); }
		}
		function resetCursor(){
			jQuery('#current_cursor_icon').remove(); 
			me.map.setOptions({draggableCursor: null, draggingCursor: null});
		}
  });
}

PaletteControl.prototype.createMarker = function(latLng, icon) {
	var me = this;
	this.create_marker = new google.maps.Marker({ position: latLng, map: map, draggable: true, icon: icon });
	infowindow.close();
	// jQuery("#new-fact img[src*='" + icon + "']").addClass('current_tag');
	var tag = jQuery("#new-fact img[src*='" + icon + "']").parent().attr('title');
	jQuery('#new-fact #fact_tag_list').val(tag);
	jQuery('#new-fact #fact_location').val(latLngString(latLng));
	setFormContent(jQuery('#new-fact').html());
  infowindow.open(map, this.create_marker);
	apply_ajax_forms();
	this.closeClickListener = google.maps.event.addListener(infowindow,'closeclick',function(){
		me.killMarker();
	});
	jQuery(document).bind('keypress', function(event) {
		if (event.keyCode == '27') {
			me.killMarker();
	  }
	});
}

PaletteControl.prototype.killMarker = function(){
	if(this.create_marker) {
		this.shutDownKillMarker();
		infowindow.close();
	}
}

PaletteControl.prototype.shutDownKillMarker = function(){
	if(this.create_marker) {
		if(this.closeClickListener) { google.maps.event.removeListener(this.closeClickListener) };
		jQuery(document).unbind('keypress');
		this.create_marker.setMap(null);
		this.create_marker = null;
	}
}
