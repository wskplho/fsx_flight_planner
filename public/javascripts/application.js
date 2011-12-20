// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  initialize();
  watchResetLink($('.reset'));
  watchChanceLink($('.chance'));
});

function initialize()
{
  var mapJquery = $('#map_canvas'),
      waypoints = [],
      rows = $('table tbody tr');

  if ( !mapJquery.length )
    return;

  rows.each(function(){
    var row = $(this),
        waypoint = {
          code: row.find('td.code').text(),
          name: row.find('td.name').text(),
          country: row.find('td.country').text(),
          latitude: parseFloat( row.find('td.latitude').text() ),
          longitude: parseFloat( row.find('td.longitude').text() ),
        };

    waypoint.point = new google.maps.LatLng( waypoint.latitude, waypoint.longitude );
    waypoints.push(waypoint);
  });

  var latitudes    = waypoints.map(function(i){ return i.latitude; }),
      longitudes   = waypoints.map(function(i){ return i.longitude; }),
      minLatitude  = Math.min.apply(null, latitudes),
      maxLatitude  = Math.max.apply(null, latitudes),
      minLongitude = Math.min.apply(null, longitudes),
      maxLongitude = Math.max.apply(null, longitudes),
      midLatitude  = (minLatitude + maxLatitude) / 2,
      midLongitude = (minLongitude + maxLongitude) / 2,
      center       = new google.maps.LatLng( midLatitude, midLongitude );

  var myOptions = {
        zoom: 3,
        center: center,
        mapTypeId: google.maps.MapTypeId.TERRAIN
      },
      map = new google.maps.Map(mapJquery[0], myOptions);
  
  for ( var i in waypoints )
  {
    new google.maps.Marker({
      position: waypoints[i].point,
      title: waypoints[i].code + ' ' + waypoints[i].name + ' ' + waypoints[i].country,
      map: map
    });
  }

  var flightPlanCoordinates = waypoints.map(function(i){ return i.point }),
      flightPath = new google.maps.Polyline({
        path: flightPlanCoordinates,
        strokeColor: "#FF0000",
        strokeOpacity: 0.5,
        strokeWeight: 5
      });

  flightPath.setMap(map);
}

function resetFields()
{
  var form = $('#new_flight'),
      start = $('#flight_start_code'),
      finish = $('#flight_finish_code'),
      aircraft = $('#flight_aircraft_id'),
      country = $('#flight_country_name');

  start.val('');
  finish.val('');
  aircraft.find('option:selected').attr('selected', false);
  country.val('');
}

function watchResetLink(jqueryObject)
{
  $(jqueryObject).click(function(){
    resetFields();
    return false;
  });
}

function watchChanceLink(jqueryObject)
{
  $(jqueryObject).click(function(){
    resetFields();
    $('#new_flight').submit();
    return false;
  });
}