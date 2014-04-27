
displayGamesForDate = (date, map) ->
   $.ajax(
         url: 'appdata/games?date=' + date,
         success: (games) -> 
            for game in games
               do (game) ->
                  marker = new google.maps.Marker
                     position: new google.maps.LatLng(parseFloat(game.lat), parseFloat(game.lon))      
                     title: game.away_team + ' vs. ' + game.home_team
                     map: map
                  
                  google.maps.event.addListener(marker, 'click', ->
                     infoWindow = new google.maps.InfoWindow()
                     infoWindow.setContent(marker.title)
                     infoWindow.open(map, marker)
                     return false;)               
         error: ->
            alert('Error retrieving games for the selected date.')
       )
   
initMap = ->
   options = 
      center:      new google.maps.LatLng(39.8111444,-98.5569364),
      zoom:        4,
      mapTypeId:   google.maps.MapTypeId.ROADMAP
      
   map = new google.maps.Map(document.getElementById("schedule-map"), options)
   displayGamesForDate new Date().toJSON().slice(0, 10), map


$(document).ready initMap
   
