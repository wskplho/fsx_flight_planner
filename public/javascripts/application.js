// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  initialize();
});

function initialize()
{
  var mapJquery = $('#map_canvas'),
      waypoints = [],
      rows = $('table tbody tr');

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

  var latitudes    = waypoints.map(function(i){ return i.latitude; })
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
  
  for each ( var waypoint in waypoints )
  {
    new google.maps.Marker({
      position: waypoint.point,
      title: waypoint.code + ' ' + waypoint.name + ' ' + waypoint.country,
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