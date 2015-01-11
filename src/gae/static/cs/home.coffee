gMap = {}
gGameMarkers = []


# formats date as mm/dd/yyyy
formatDate = (date) ->
   date.toJSON().slice(0, 10)

dateChanged = ->
   displayGamesForDate(formatDate(new Date($("#datepicker").val())))

displayGamesForDate = (date) ->
   aMarker.setMap(null) for aMarker in gGameMarkers
   gGameMarkers = []
   lastInfoWindow = null
   
   $.ajax(
         url: 'appdata/games?date=' + date,
         success: (games) -> 
            for game in games
               do (game) ->
                  marker = new google.maps.Marker
                     position: new google.maps.LatLng(parseFloat(game.lat), parseFloat(game.lon))      
                     title: game.away_team + ' @ ' + game.home_team
                     map: gMap
                  
                  source = $("#info-window").html()
                  template = Handlebars.compile(source)
                  context = {away_team: game.away_team_abbr, home_team: game.home_team_abbr, game_time: game.game_time}
                  google.maps.event.addListener(marker, 'click', ->
                     lastInfoWindow.close() if lastInfoWindow isnt null
                     lastInfoWindow = new google.maps.InfoWindow()
                     lastInfoWindow.setContent(template(context))
                     lastInfoWindow.open(gMap, marker)
                     return false)

                  gGameMarkers.push(marker)
         error: (response) ->
            console.log(response)
            #alert('Error retrieving games for the selected date.')
       )
   
initMap = ->
   options = 
      center: new google.maps.LatLng(39.8111444,-98.5569364),
      zoom: 4,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControl: false
      styles: [
         featureType: "all",
         elementType: "labels",
         stylers: [visibility: "off"]
      ]

   gMap = new google.maps.Map(document.getElementById("schedule-map"), options)
   displayGamesForDate(new Date().toJSON().slice(0, 10))
   
   source = $("#trip-controls").html()
   template = Handlebars.compile(source)
   gMap.controls[google.maps.ControlPosition.TOP_RIGHT].push($(template())[0])
           
   # TODO: Revisit this...has to be a better way
   setTimeout(-> 
      $("#datepicker").datepicker()
      $("#datepicker").change(dateChanged)
         
      # preventing keyboard-entered dates
      $("#datepicker").keyup( (event)->
         false)
    1000)

$(document).ready initMap
